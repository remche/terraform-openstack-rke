output "default_secgroup_name" {
  value = openstack_networking_secgroup_v2.default_secgroup.name
}

output "master_secgroup_name" {
  value = openstack_networking_secgroup_v2.master_secgroup.name
}
