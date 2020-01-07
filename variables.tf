variable "cluster_name" {
  type = string
  default = "nova-cluster"
}

variable "ssh_key_file" {
  type = string
  default = "~/.ssh/id_rsa.pub"
}

variable "nodes_net_cidr" {
  type = string
  default = "192.168.42.0/24"
}

variable "public_net_name" {
  type = string
  default = "public"
}
