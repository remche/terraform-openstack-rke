resource "openstack_networking_secgroup_v2" "default_secgroup" {
  name        = "${var.default_name_prefix}-secgroup"
  description = "Security gropup for RKE"
}

resource "openstack_networking_secgroup_rule_v2" "default_rule" {

  direction         = "ingress"
  ethertype         = "IPv4"
  remote_group_id   = openstack_networking_secgroup_v2.default_secgroup.id
  security_group_id = openstack_networking_secgroup_v2.default_secgroup.id
}

resource "openstack_networking_secgroup_v2" "master_secgroup" {
  name        = "${var.master_name_prefix}-secgroup"
  description = "Security gropup for RKE"
}

resource "openstack_networking_secgroup_rule_v2" "master_ingress" {
  count = length(var.master_rules)

  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = var.master_rules[count.index].protocol
  port_range_min    = var.master_rules[count.index].port
  port_range_max    = var.master_rules[count.index].port
  remote_ip_prefix  = var.master_rules[count.index].source
  security_group_id = openstack_networking_secgroup_v2.master_secgroup.id

}
