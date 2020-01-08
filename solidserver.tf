variable "solidserver_space" {
  type = string
}

variable "solidserver_subnet" {
  type = string
}

variable "dns_domain" {
  type = string
}

module "ipam_master" {
  source             = "./modules/ipam"
  address_count      = var.master_count
  solidserver_space  = var.solidserver_space
  solidserver_subnet = var.solidserver_subnet
  dns_domain         = var.dns_domain
  dns_names          = module.master.nodes[*].name
  ips                = module.master.nodes[*].floating_ip
}
