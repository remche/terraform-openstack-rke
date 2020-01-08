resource "solidserver_ip_address" "solid_address" {
  count      = var.address_count
  space      = var.solidserver_space
  subnet     = var.solidserver_subnet
  name       = "${var.dns_names[count.index]}.${var.dns_domain}"
  request_ip = var.ips[count.index]
}
