resource "null_resource" "wait_for_master_ssh" {
  for_each = var.master_nodes
  triggers = {
    node_instance_id = each.value.id
  }
  connection {
    host        = each.value.floating_ip
    user        = var.system_user
    private_key = var.use_ssh_agent ? null : file(var.ssh_key_file)
    agent       = var.use_ssh_agent
  }
  provisioner "remote-exec" {
    inline = var.wait_for_commands
  }
}

resource "null_resource" "wait_for_edge_ssh" {
  for_each = var.edge_nodes
  triggers = {
    node_instance_id = each.value.id
  }
  connection {
    host        = each.value.floating_ip
    user        = var.system_user
    private_key = var.use_ssh_agent ? null : file(var.ssh_key_file)
    agent       = var.use_ssh_agent
  }
  provisioner "remote-exec" {
    inline = var.wait_for_commands
  }
}

resource "null_resource" "wait_for_worker_ssh" {
  for_each = var.worker_nodes
  triggers = {
    node_instance_id = each.value.id
  }
  connection {
    bastion_host = var.bastion_host
    host         = each.value.internal_ip
    user         = var.system_user
    private_key  = var.use_ssh_agent ? null : file(var.ssh_key_file)
    agent        = var.use_ssh_agent
  }
  provisioner "remote-exec" {
    inline = var.wait_for_commands
  }
}

data "openstack_identity_auth_scope_v3" "scope" {
  name = "auth_scope"
}

resource "rke_cluster" "cluster" {

  depends_on   = [var.rke_depends_on, null_resource.wait_for_master_ssh,
  null_resource.wait_for_edge_ssh, null_resource.wait_for_worker_ssh]
  cluster_name = var.cluster_name

  dynamic nodes {
    for_each = var.master_nodes
    content {
      address           = nodes.value.floating_ip != "" ? nodes.value.floating_ip : nodes.value.internal_ip
      internal_address  = nodes.value.internal_ip
      hostname_override = nodes.key
      user              = var.system_user
      role              = ["controlplane", "etcd"]
      labels            = var.master_labels
      dynamic taints {
        for_each = var.master_taints
        content {
          key    = lookup(taints.value, "key")
          value  = lookup(taints.value, "value")
          effect = lookup(taints.value, "effect", "NoSchedule")
        }
      }
    }
  }

  dynamic nodes {
    for_each = var.edge_nodes
    content {
      address           = nodes.value.floating_ip != "" ? nodes.value.floating_ip : nodes.value.internal_ip
      internal_address  = nodes.value.internal_ip
      hostname_override = nodes.key
      user              = var.system_user
      role              = ["worker"]
      labels            = var.edge_labels
      dynamic taints {
        for_each = var.edge_taints
        content {
          key    = lookup(taints.value, "key")
          value  = lookup(taints.value, "value")
          effect = lookup(taints.value, "effect", "NoSchedule")
        }
      }
    }
  }

  dynamic nodes {
    for_each = var.worker_nodes
    content {
      address           = nodes.value.floating_ip != "" ? nodes.value.floating_ip : nodes.value.internal_ip
      internal_address  = nodes.value.internal_ip
      hostname_override = nodes.key
      user              = var.system_user
      role              = ["worker"]
      labels            = var.worker_labels
      dynamic taints {
        for_each = var.worker_taints
        content {
          key    = lookup(taints.value, "key")
          value  = lookup(taints.value, "value")
          effect = lookup(taints.value, "effect", "NoSchedule")
        }
      }
    }
  }

  bastion_host {
    address = var.bastion_host
    user    = var.system_user
  }

  ssh_agent_auth = var.use_ssh_agent
  ssh_key_path   = var.ssh_key_file

  kubernetes_version = var.k8s_version

  network {
    mtu = var.mtu
  }

  ingress {
    provider      = var.deploy_nginx ? "nginx" : "none"
    node_selector = { "node-role.kubernetes.io/edge" = "true" }
  }

  dynamic cloud_provider {
    for_each = var.cloud_provider ? [1] : []
    content {
      name = "openstack"
      openstack_cloud_provider {
        global {
          username  = data.openstack_identity_auth_scope_v3.scope.user_name
          password  = var.os_password
          auth_url  = var.os_auth_url
          tenant_id = data.openstack_identity_auth_scope_v3.scope.project_id
          domain_id = data.openstack_identity_auth_scope_v3.scope.project_domain_id
        }
      }
    }
  }

  addons = join("---\n", [templatefile("${path.module}/addons/cinder.yml.tmpl",
    { deploy = var.cloud_provider, types = var.storage_types, default_storage = var.default_storage }),
    templatefile("${path.module}/addons/traefik2.yml.tmpl",
  { deploy = var.deploy_traefik, acme_email = var.acme_email, image_tag = var.traefik_image_tag })])

  addons_include = var.addons_include != null ? [for addon in var.addons_include : addon] : null
}

resource "local_file" "kube_cluster_yaml" {
  count             = var.write_kubeconfig ? 1 : 0
  filename          = "${path.root}/kube_config_cluster.yml"
  sensitive_content = rke_cluster.cluster.kube_config_yaml
}
