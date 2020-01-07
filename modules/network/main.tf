resource "openstack_networking_network_v2" "nodes_net" {
  name           = "${var.cluster_name}-nodes-net"
  admin_state_up = "true"
  port_security_enabled = "false"
}
