resource "openstack_networking_secgroup_v2" "secgroup" {
  name        = "${var.name_prefix}-secgroup"
  description = "Security gropup for RKE"
}

resource "openstack_networking_secgroup_rule_v2" "default_rule" {
  direction         = "ingress"
  ethertype         = "IPv4"
  remote_group_id   = openstack_networking_secgroup_v2.secgroup.id
  security_group_id = openstack_networking_secgroup_v2.secgroup.id
}

resource "openstack_networking_secgroup_rule_v2" "tunnel_rule" {
  direction         = "ingress"
  ethertype         = "IPv4"
  remote_ip_prefix  = var.bastion_host
  security_group_id = openstack_networking_secgroup_v2.secgroup.id
}

resource "openstack_networking_secgroup_rule_v2" "rules" {
  count = length(var.rules)
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = var.rules[count.index].protocol
  port_range_min    = var.rules[count.index].port
  port_range_max    = var.rules[count.index].port
  remote_ip_prefix  = var.rules[count.index].source
  security_group_id = openstack_networking_secgroup_v2.secgroup.id
}
