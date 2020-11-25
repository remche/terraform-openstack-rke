variable "name_prefix" {
  type = string
}

variable "subnet" {
}

variable "secgroup_id" {
  type = string
}

variable "floating_network" {
  type = string
}

variable "lb_members" {
  type = map(map(string))
}
