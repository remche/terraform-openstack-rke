variable "name_prefix" {
  type = string
}

variable "subnet_name" {
  type = string
}

variable "secgroup_name" {
  type = string
}

variable "floating_network" {
  type = string
}

variable "lb_members" {
  type = map(map(string))
}
