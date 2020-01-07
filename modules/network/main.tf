resource "openstack_networking_network_v2" "nodes_net" {
  name           = "${var.neutron_cidr}-internal-net"
  admin_state_up = "true"
  port_security_enabled = "false"
}
