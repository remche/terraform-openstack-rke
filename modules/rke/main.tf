resource "rke_cluster" "cluster" {

  depends_on = [var.rke_depends_on]

  dynamic nodes {
    for_each = var.master_nodes
    content {
      address           = nodes.value.floating_ip != "" ? nodes.value.floating_ip : nodes.value.internal_address
      internal_address  = nodes.value.internal_ip
      hostname_override = nodes.value.name
      user              = var.system_user
      role              = ["controlplane", "worker", "etcd"]
      ssh_key           = file(var.ssh_key_file)
    }
  }

  dynamic nodes {
    for_each = var.worker_nodes
    content {
      address           = nodes.value.floating_ip != "" ? nodes.value.floating_ip : nodes.value.internal_ip
      internal_address  = nodes.value.internal_ip
      hostname_override = nodes.value.name
      user              = var.system_user
      role              = ["worker"]
      ssh_key           = file(var.ssh_key_file)
    }
  }

  bastion_host {
    address      = var.master_nodes[0].floating_ip
    user         = var.system_user
    ssh_key_path = file(var.ssh_key_file)
  }

  ssh_agent_auth = var.use_ssh_agent

}

resource "local_file" "kube_cluster_yaml" {
  filename = "${path.root}/kube_config_cluster.yml"
  content  = rke_cluster.cluster.kube_config_yaml
}
