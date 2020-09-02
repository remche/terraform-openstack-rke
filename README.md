# terraform-openstack-rke

[![Terraform Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/remche/rke/openstack)
[![Build Status](https://travis-ci.com/remche/terraform-openstack-rke.svg?branch=master)](https://travis-ci.com/remche/terraform-openstack-rke)

[Terraform](https://www.terraform.io/) module to deploy [Kubernetes](https://kubernetes.io) with [RKE](https://rancher.com/docs/rke/latest/en/) on [OpenStack](https://www.openstack.org/).

Inspired by [Marco Capuccini](https://github.com/mcapuccini/terraform-openstack-rke) work, rewritten from scratch for Terraform 0.12+ and new [terraform-rke-provider](https://github.com/rancher/terraform-provider-rke).

## Table of contents
- [Prerequisites](#prerequisites)
- [Upgrading to Terraform 0.13](#terraform-0.13-upgrade)
- [Examples](#examples)
- [Documentation](#documentation)

## Prerequisites

- [Terraform](https://www.terraform.io/) 0.13+. For Terraform 0.12.x, use terraform/v0.12 branch.
- [OpenStack](https://docs.openstack.org/zh_CN/user-guide/common/cli-set-environment-variables-using-openstack-rc.html) environment properly sourced.
- A Openstack image fullfiling [RKE requirements](https://rancher.com/docs/rke/latest/en/os/).
- At least one Openstack floating IP.

## Terraform 0.13 upgrade

terraform-openstack-rke >= 0.5 supports Terraform >= 0.13. Some changes in the way Terraform manage providers require manual operations.

```hcl
terraform 0.13upgrade
terraform  state replace-provider 'registry.terraform.io/-/rke' 'registry.terraform.io/rancher/rke'
terraform init
```

For more informations see [Upgrading to Terraform v0.13](https://www.terraform.io/upgrade-guides/0-13.html)

> :warning: There is some deep changes between 0.4 and 0.5 branches. That will lead to a replacement of the nodes and the rke cluster resources :warning:

## Examples
### Minimal example with master node as egde node and two worker nodes

```hcl
# Consider using 'export TF_VAR_os_auth_url=$OS_AUTH_URL'
variable "os_auth_url"{}
# Consider using 'export TF_VAR_os_password=$OS_PASSWORD'
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
# Consider using 'export TF_VAR_os_password=$OS_PASSWORD'
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

See [USAGE.md](USAGE.md) for all available options.

### Keypair

You can either specify a ssh key file to generate new keypair via `ssh_key_file` (default) or specify already existent keypair via `ssh_keypair_name`.

> :warning: Default config will try to use  [ssh agent](https://linux.die.net/man/1/ssh-agent) for ssh connections to the nodes. Add `use_ssh_agent = false` if you don't use it.

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

You can set [affinity policy](https://www.terraform.io/docs/providers/openstack/r/compute_servergroup_v2.html#policies) for each nodes group (master, worker, edge) via `{master,worker,edge}_server_affinity`. Default is `soft-anti-affinity`.

> :warning: `soft-anti-affinity` and `soft-affinity` needs Compute service API 2.15 or above.

You can use `wait_for_commands` to specify a list of commands to be run before invoking RKE. It can be useful when installing Docker at provision time (note that cooking your image embedding Docker with [Packer](https://packer.io) is a better practice though) :
`wait_for_commands = ["while docker info ; [ $? -ne 0 ]; do echo wait for docker; sleep 30 ; done"]`

### Kubernetes version

You can specify kubernetes version with `kubernetes_version` variables. Refer to RKE supported version.

### Cloud provider

The module will deploy [Openstack Cloud Provider](https://rancher.com/docs/rke/latest/en/config-options/cloud-providers/openstack/). 
It will create the [Kubernetes Storageclasses](https://kubernetes.io/docs/concepts/storage/storage-classes/) for Cinder. If you have many Cinder storage type, you can specify it in [storage_types](variables.tf#L164) variable.

You can disable cloud provider via `cloud_provider` variable.

### Reverse Proxy

The module will deploy Traefik by default but you can use nginx-ingress instead. Note that nginx is not supported when master node is the edge node.

### User Add-Ons

You can specify you own [User Add_Ons](https://rancher.com/docs/rke/latest/en/config-options/add-ons/user-defined-add-ons/) with [addons_include](variables.tf#176) variable.

### Usage with [RancherOS](https://rancher.com/rancher-os/)

RancherOS **needs** a node config drive to be configured. You can also provide a cloud config file :

```hcl
image_name          = "rancheros-1.5.5-x86_64"
system_user         = "rancher"
nodes_config_drive  = "true"
user_data_file      = "rancher.yml"
```

### Usage with [Terraform Kubernetes Provider](https://www.terraform.io/docs/providers/kubernetes/index.html) and [Helm Provider](https://www.terraform.io/docs/providers/helm/index.html)

> :warning: **Interpolating provider variables from module output is not the recommended way to achieve integration**. See [here](https://www.terraform.io/docs/providers/kubernetes/index.html) and [here](https://www.terraform.io/docs/configuration/providers.html#provider-configuration).
>
> Use of a data sources is recommended.

(Not recommended) You can use this module to populate [Terraform Kubernetes Provider](https://www.terraform.io/docs/providers/kubernetes/index.html) :

```hcl
provider "kubernetes" {
  host     = module.rke.rke_cluster.api_server_url
  username = module.rke.rke_cluster.kube_admin_user

  client_certificate     = module.rke.rke_cluster.client_cert
  client_key             = module.rke.rke_cluster.client_key
  cluster_ca_certificate = module.rke.rke_cluster.ca_crt
}
```

Recommended way needs two `apply` operations, and setting the proper `terraform_remote_state` data source :

```hcl
provider "kubernetes" {
  host     = data.terraform_remote_state.rke.outputs.cluster.api_server_url
  username = data.terraform_remote_state.rke.outputs.cluster.kube_admin_user
  client_certificate     = data.terraform_remote_state.rke.outputs.cluster.client_cert
  client_key             = data.terraform_remote_state.rke.outputs.cluster.client_key
  cluster_ca_certificate = data.terraform_remote_state.rke.outputs.cluster.ca_crt
  load_config_file = "false"
}
```
