output "floating_ips" {
  value = openstack_compute_floatingip_v2.floating_ip[*].address
}
