variable "cluster_name" {
  type = string
  default = "nova-cluster"
}

variable "ssh_key_file" {
  type = string
  default = "~/.ssh/id_rsa.pub"
}
