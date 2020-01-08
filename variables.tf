variable "cluster_name" {
  type    = string
  default = "nova-cluster"
}

variable "ssh_key_file" {
  type    = string
  default = "~/.ssh/id_rsa.pub"
}

variable "nodes_net_cidr" {
  type    = string
  default = "192.168.42.0/24"
}

variable "public_net_name" {
  type    = string
  default = "public"
}

variable "image_name" {
  type    = string
  default = "ubuntu-18.04-docker-x86_64"
}

variable "master_count" {
  type    = number
  default = 2
}

variable "worker_count" {
  type    = number
  default = 1
}

variable "master_flavor_name" {
  type    = string
  default = "m1.small"
}

variable "worker_flavor_name" {
  type    = string
  default = "m1.small"
}

variable "system_user" {
  type	  = string
  default = "ubuntu"
}
