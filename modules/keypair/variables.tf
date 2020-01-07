variable "cluster_name" {
  type = string
}

variable "ssh_key_file" {
  type = string
  default = "~/.ssh/id_rsa"
}
