output "associate_floating_ip" {
  value = openstack_compute_floatingip_associate_v2.associate_floating_ip[*]
}

data "null_data_source" "nodes" {
  count = var.nodes_count
  inputs = {
    id          = openstack_compute_instance_v2.instance[count.index].id
    internal_ip = openstack_compute_instance_v2.instance[count.index].access_ip_v4
    floating_ip = var.assign_floating_ip ? openstack_networking_floatingip_v2.floating_ip[count.index].address : ""
  }
}

output "nodes" {
  value = zipmap(openstack_compute_instance_v2.instance[*].name, data.null_data_source.nodes[*].outputs)
}
