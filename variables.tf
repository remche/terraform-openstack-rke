####################
# Global variables #
####################

variable "cluster_name" {
  type        = string
  default     = "rke"
  description = "Name of the cluster"
}

variable "ssh_keypair_name" {
  type        = string
  default     = null
  description = "SSH keypair name"
}

variable "ssh_key_file" {
  type        = string
  default     = "~/.ssh/id_rsa"
  description = "Local path to SSH key"
}

######################
# Secgroup variables #
######################

variable "secgroup_rules" {
  type = list(any)
  default = [{ "source" = "0.0.0.0/0", "protocol" = "tcp", "port" = 22 },
    { "source" = "0.0.0.0/0", "protocol" = "tcp", "port" = 6443 },
    { "source" = "0.0.0.0/0", "protocol" = "tcp", "port" = 80 },
    { "source" = "0.0.0.0/0", "protocol" = "tcp", "port" = 443 }
  ]
  description = "Security group rules"
}

#####################
# Network variables #
#####################

variable "nodes_net_cidr" {
  type        = string
  default     = "192.168.42.0/24"
  description = "Neutron network CIDR"
}

variable "public_net_name" {
  type        = string
  description = "External network name"
}

variable "dns_servers" {
  type        = list(string)
  default     = null
  description = "DNS servers"
}

variable "dns_domain" {
  type        = string
  default     = null
  description = "DNS domain for DNS integration. DNS domain names must have a dot at the end"
}

variable "enable_loadbalancer" {
  type        = bool
  default     = false
  description = "Enable Octabia LB for master/edge nodes"
}

##################
# Node variables #
##################

variable "image_name" {
  type        = string
  description = "Name of image nodes (must fullfill RKE requirements)"
}

variable "master_count" {
  type        = number
  default     = 1
  description = "Number of master nodes (should be odd number...)"
}

variable "edge_count" {
  type        = number
  default     = 0
  description = "Number of edge nodes"
}

variable "worker_count" {
  type        = number
  default     = 2
  description = "Number of woker nodes"
}

variable "master_flavor_name" {
  type        = string
  description = "Master flavor name"
}

variable "worker_flavor_name" {
  type        = string
  description = "Worker flavor name"

}

variable "edge_flavor_name" {
  type        = string
  default     = null
  description = "Edge flavor name. Will use worker_flavor_name if not set"
}

variable "master_server_affinity" {
  type        = string
  default     = "soft-anti-affinity"
  description = "Master server group affinity"
}

variable "worker_server_affinity" {
  type        = string
  default     = "soft-anti-affinity"
  description = "Worker server group affinity"
}

variable "edge_server_affinity" {
  type        = string
  default     = "soft-anti-affinity"
  description = "Edge server group affinity"
}

variable "nodes_config_drive" {
  type        = bool
  default     = "false"
  description = "Whether to use the config_drive feature to configure the instances"
}

variable "user_data_file" {
  type        = string
  default     = null
  description = "User data file to provide when launching the instance"
}

variable "boot_from_volume" {
  type        = bool
  default     = false
  description = "Boot nodes from volume"
}

variable "boot_volume_size" {
  type        = number
  default     = 20
  description = "The size of the boot volume"
}

variable "availability_zones" {
  type        = list(string)
  default     = []
  description = "The list of AZs to deploy nodes into"
}

variable "use_octavia" {
  type        = bool
  default     = false
  description = "Use Octavia LBaaS instead of Neutron Networking"
}

#################
# RKE variables #
#################

variable "system_user" {
  type        = string
  default     = "ubuntu"
  description = "Default OS image user"
}

variable "use_ssh_agent" {
  type        = bool
  default     = "true"
  description = "Whether to use ssh agent"
}

variable "bastion_host" {
  type        = string
  default     = null
  description = "Bastion host. Will use first master node if not set"
}

variable "wait_for_commands" {
  type        = list(string)
  default     = ["# Connected !"]
  description = "Commands to run on nodes before running RKE"
}

variable "os_auth_url" {
  type        = string
  description = "Openstack auth_url. Consider using export TF_VAR_os_auth_url=$OS_AUTH_URL"
}

variable "os_password" {
  type        = string
  description = "Openstack password. Consider using export TF_VAR_os_password=$OS_PASSWORD"
}

variable "master_labels" {
  type        = map(string)
  default     = { "node-role.kubernetes.io/master" = "true", "node-role.kubernetes.io/edge" = "true" }
  description = "Master labels. Ingress controller will run on nodes with egde label"
}

variable "worker_labels" {
  type        = map(string)
  default     = { "node-role.kubernetes.io/worker" = "true" }
  description = "Worker labels"
}

variable "edge_labels" {
  type        = map(string)
  default     = { "node-role.kubernetes.io/worker" = "true" }
  description = "Edge labels. Ingress controller will run on nodes with egde label"
}

variable "master_taints" {
  type        = list(map(string))
  default     = []
  description = "Master taints"
}

variable "worker_taints" {
  type        = list(map(string))
  default     = []
  description = "Worker taints"
}

variable "edge_taints" {
  type        = list(map(string))
  default     = []
  description = "Edge taints"
}

variable "kubernetes_version" {
  type        = string
  default     = null
  description = "Kubernetes version (RKE)"
}

variable "cni_mtu" {
  type        = number
  default     = 0
  description = "CNI MTU"
}

variable "cloud_provider" {
  type        = bool
  default     = "true"
  description = "Deploy cloud provider"
}

variable "ignore_volume_az" {
  type        = bool
  default     = "false"
  description = "Ignore volume availability zone"
}

variable "deploy_traefik" {
  type        = bool
  default     = "true"
  description = "Whether to deploy traefik. Mandatory if no edge nodes"
}

variable "traefik_image_tag" {
  type        = string
  default     = "2.2"
  description = "Traefik version"
}

variable "deploy_nginx" {
  type        = bool
  default     = "false"
  description = "Whether to deploy nginx RKE addon"
}

variable "acme_email" {
  type        = string
  default     = "example@example.com"
  description = "Email for Let's Encrypt"
}

variable "storage_types" {
  type        = list(string)
  default     = null
  description = "Cinder storage types"
}

variable "default_storage" {
  type        = string
  default     = null
  description = "Default storage class"
}

variable "addons_include" {
  type        = list(string)
  default     = null
  description = "RKE YAML files for add-ons"
}

variable "write_kubeconfig" {
  type        = bool
  default     = "true"
  description = "Write kubeconfig file to disk"
}
