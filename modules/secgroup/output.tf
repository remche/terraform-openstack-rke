output "secgroup_name" {
  value = openstack_networking_secgroup_v2.secgroup.name
}

output "secgroup_rules" {
  value = openstack_networking_secgroup_rule_v2.rules
}
