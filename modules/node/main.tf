resource "openstack_compute_instance_v2" "instance" {
  count       = var.nodes_count
  name        = "${var.name_prefix}-${format("%03d", count.index)}"
  image_name  = var.image_name
  flavor_name = var.flavor_name
  key_pair    = var.keypair_name

  network {
    name = var.network_name
  }

  security_groups = [var.secgroup_name]
}

resource "openstack_compute_floatingip_v2" "floating_ip" {
  count = var.assign_floating_ip ? var.nodes_count : 0
  pool  = var.floating_ip_pool
}

resource "openstack_compute_floatingip_associate_v2" "associate_floating_ip" {
  count       = var.assign_floating_ip ? var.nodes_count : 0
  floating_ip = openstack_compute_floatingip_v2.floating_ip[count.index].address
  instance_id = openstack_compute_instance_v2.instance[count.index].id
}
