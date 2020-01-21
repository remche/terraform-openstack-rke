# terraform-openstack-rke

[![Terraform Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/remche/rke/openstack)

[Terraform](https://www.terraform.io/) module to deploy [Kubernetes](https://kubernetes.io) with [RKE](https://rancher.com/docs/rke/latest/en/) on [OpenStack](https://www.openstack.org/).

Inspired by [Marco Cappucini](https://github.com/mcapuccini/terraform-openstack-rke) work, rewrited from scratch for Terraform 0.12+ and new [terraform-rke-provider](https://github.com/rancher/terraform-provider-rke).

## Table of contents
- [Prerequisites](#prerequisites)
- [Examples](#examples)
- [Documentation](#documentation)

## Prerequisites

- [Terraform](https://www.terraform.io/) 0.12+
- [terraform-provider-rke](https://github.com/rancher/terraform-provider-rke) v1.0.0-beta1+
- [OpenStack](https://docs.openstack.org/zh_CN/user-guide/common/cli-set-environment-variables-using-openstack-rc.html) environment properly sourced.
- A Openstack image fullfiling [RKE requirements](https://rancher.com/docs/rke/latest/en/os/).
- At least one Openstack floating IP.

## Examples
### Minimal example with master node as egde node and two worker nodes

```hcl
# Consider using 'export TF_VAR_os_auth_url=$OS_AUTH_URL'
variable "os_auth_url"{}
# Consider using 'export TF_VAR_os_password=$OS_AUTH_URL'
variable "os_password"{}

 module "rke" {
  source  = "remche/rke/openstack"
  image_name          = "ubuntu-18.04-docker-x86_64"
  public_net_name     = "public"
  master_flavor_name  = "m1.small"
  worker_flavor_name  = "m1.small"
  os_auth_url         = var.os_auth_url
  os_password         = var.os_password
}
```

###  Minimal example with two egde nodes and one worker nodes

```hcl
# Consider using 'export TF_VAR_os_auth_url=$OS_AUTH_URL'
variable "os_auth_url"{}
# Consider using 'export TF_VAR_os_password=$OS_AUTH_URL'
variable "os_password"{}

 module "rke" {
  source  = "remche/rke/openstack"
  image_name          = "ubuntu-18.04-docker-x86_64"
  public_net_name     = "public"
  master_flavor_name  = "m1.small"
  worker_flavor_name  = "m1.small"
  edge_count          = 2
  worker_count        = 1
  master_labels       = {"node-role.kubernetes.io/master" = "true"}
  edge_labels         = {"node-role.kubernetes.io/edge" = "true"}
  os_auth_url         = var.os_auth_url
  os_password         = var.os_password
}
```

## Documentation

See [variables.tf](variables.tf) for all available options, most of them are self-explanatory.

### Secgroup

You can define your own rules (e.g. limiting port 22 and 6443 to admin box).

```hcl
secgroup_rules      = [ { "source" = "x.x.x.x", "protocol" = "tcp", "port" = 22 },
                        { "source" = "x.x.x.x", "protocol" = "tcp", "port" = 6443 },
                        { "source" = "0.0.0.0/0", "protocol" = "tcp", "port" = 80 },
                        { "source" = "0.0.0.0/0", "protocol" = "tcp", "port" = 443}
                      ]
```

### Nodes

Default config will deploy one master and two worker nodes. It will use Traefik (nginx not supported in this case).
You can define edge nodes (see [above](#minimal-example-with-two-egde-nodes-and-one-worker-nodes)).

### Usage with [Terraform Kubernetes Provider](https://www.terraform.io/docs/providers/kubernetes/index.html)

You can use this module to populate [Terraform Kubernetes Provider](https://www.terraform.io/docs/providers/kubernetes/index.html) :

```hcl
provider "kubernetes" {
  host     = module.rke.rke_cluster.api_server_url
  username = module.rke.rke_cluster.kube_admin_user

  client_certificate     = module.rke.rke_cluster.client_cert
  client_key             = module.rke.rke_cluster.client_key
  cluster_ca_certificate = module.rke.rke_cluster.ca_crt
}

resource "kubernetes_namespace" "ns" {
  metadata {
    name = "my-namespace"
  }
}
```
