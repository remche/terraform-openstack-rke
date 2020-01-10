# Global variables

variable "cluster_name" {
  type    = string
  default = "nova-cluster"
}

variable "ssh_key_file" {
  type    = string
  default = "~/.ssh/id_rsa"
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


