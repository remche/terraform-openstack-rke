variable "rke_depends_on" {
  type    = any
  default = null
}

variable "master_nodes" {
}

variable "worker_nodes" {
}

variable "edge_nodes" {
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

variable "bastion_host" {
  type    = string
}

variable "os_auth_url" {
  type    = string
}

variable "os_password" {
  type    = string
}

variable "master_labels" {
  type    = map(string)
}

variable "worker_labels" {
  type    = map(string)
}

variable "edge_labels" {
  type    = map(string)
}

variable "k8s_version" {
  type    = string
}

variable "mtu" {
  type    = number
  default = 0
}

variable "deploy_traefik" {
  type    = bool
}

variable "deploy_nginx" {
  type    = bool
}

variable "acme_email" {
  type    = string
}

variable "storage_types" {
  type    = list(string)
}

variable "default_storage" {
  type    = string
}

variable "addons_include" {
  type    = list(string)
}
