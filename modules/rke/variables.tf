variable "rke_depends_on" {
  type    = any
  default = null
}

variable "master_nodes" {
}

variable "worker_nodes" {
}

variable "system_user" {
  type = string
}

variable "ssh_key_file" {
  type = string
}

variable "use_ssh_agent" {
  type    = bool
  default = "true"
}