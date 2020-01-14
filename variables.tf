# Global variables

variable "cluster_name" {
  type    = string
  default = "nova-cluster"
}

variable "ssh_key_file" {
  type    = string
  default = "~/.ssh/id_rsa"
}

# Secgroup variables

variable secgroup_rules {
  type        = list
  default     = [ { "source" = "0.0.0.0/0", "protocol" = "tcp", "port" = 22 },
                  { "source" = "0.0.0.0/0", "protocol" = "tcp", "port" = 6443 },
                  { "source" = "0.0.0.0/0", "protocol" = "tcp", "port" = 80 },
                  { "source" = "0.0.0.0/0", "protocol" = "tcp", "port" = 443}
                ]
}

# Network variables

variable "nodes_net_cidr" {
  type    = string
  default = "192.168.42.0/24"
}

variable "public_net_name" {
  type    = string
  default = "public"
}

variable "dns_servers" {
  type    = list(string)
  default = null
}

# Node variables

variable "image_name" {
  type    = string
  default = "ubuntu-18.04-docker-x86_64"
}

variable "master_count" {
  type    = number
  default = 1
}

variable "edge_count" {
  type    = number
  default = 0
}

variable "worker_count" {
  type    = number
  default = 2
}

variable "master_flavor_name" {
  type    = string
  default = "m1.small"
}

variable "worker_flavor_name" {
  type    = string
  default = "m1.small"
}

# RKE variables

variable "system_user" {
  type	  = string
  default = "ubuntu"
}

variable "use_ssh_agent" {
  type    = bool
  default = "true"
}

variable "bastion_host" {
  type    = string
  default = null
}

variable "os_auth_url" {
  type    = string
}

variable "os_password" {
  type    = string
}

variable "master_labels" {
  type    = map(string)
  default = { "node-role.kubernetes.io/master" = "true", "node-role.kubernetes.io/edge" = "true" }
}

variable "worker_labels" {
  type    = map(string)
  default = { "node-role.kubernetes.io/worker" = "true" }
}

variable "edge_labels" {
  type    = map(string)
  default = {"node-role.kubernetes.io/worker" = "true" }
}

variable "deploy_traefik" {
  type    = bool
  default = "true"
}

variable "deploy_nginx" {
  type    = bool
  default = "false"
}

variable "acme_email" {
  type    = string
  default = "example@example.com"
}

variable "storage_types" {
  type    = list(string)
  default = null
}

variable "default_storage" {
  type    = string
  default = null
}
