variable "address_count" {
  type = number
}

variable "solidserver_space" {
  type    = string
}

variable "solidserver_subnet" {
  type    = string
}

variable "dns_domain" {
  type    = string
}

variable "dns_names" {
  type    = list(string)
}

variable "ips" {
  type    = list(string)
}
