output "associate_floating_ip" {
  value = openstack_compute_floatingip_associate_v2.associate_floating_ip[*]
}

output "nodes" {
  value = data.null_data_source.nodes[*].outputs
}
