output "names" {
  value = openstack_compute_instance_v2.instance[*].name
}

output "floating_ips" {
  value = openstack_compute_floatingip_v2.floating_ip[*].address
}
