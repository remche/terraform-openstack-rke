data "openstack_networking_network_v2" "floating_net" {
  name = var.floating_network
}

data "openstack_networking_subnet_v2" "subnet" {
  name = var.subnet_name
}

data "openstack_networking_secgroup_v2" "secgroup" {
  name = var.secgroup_name
}

resource "openstack_lb_loadbalancer_v2" "loadbalancer" {
  name = var.name_prefix
  vip_subnet_id = data.openstack_networking_subnet_v2.subnet.id
  security_group_ids = [data.openstack_networking_secgroup_v2.secgroup.id]
}

resource "openstack_lb_listener_v2" "https" {
  name            = "${var.name_prefix}-https-listener"
  protocol        = "TCP"
  protocol_port   = 443
  loadbalancer_id = openstack_lb_loadbalancer_v2.loadbalancer.id
}

resource "openstack_lb_pool_v2" "https" {
  name        = "${var.name_prefix}-https-pool"
  protocol    = "TCP"
  listener_id = openstack_lb_listener_v2.https.id
  lb_method   = "ROUND_ROBIN"
}

resource "openstack_lb_monitor_v2" "https" {
  name        = "${var.name_prefix}-https-monitor"
  pool_id     = openstack_lb_pool_v2.https.id
  type        = "TCP"
  timeout     = 1
  delay       = 1
  max_retries = 3
}

resource "openstack_lb_member_v2" "https" {
  for_each      = var.lb_members
  name          = each.key
  pool_id       = openstack_lb_pool_v2.https.id
  address       = each.value.internal_ip
  protocol_port = 443
}

resource "openstack_lb_listener_v2" "http" {
  name            = "${var.name_prefix}-http-listener"
  protocol        = "TCP"
  protocol_port   = 80
  loadbalancer_id = openstack_lb_loadbalancer_v2.loadbalancer.id
}

resource "openstack_lb_pool_v2" "http" {
  name        = "${var.name_prefix}-http-pool"
  protocol    = "TCP"
  listener_id = openstack_lb_listener_v2.http.id
  lb_method   = "ROUND_ROBIN"
}

resource "openstack_lb_monitor_v2" "http" {
  name        = "${var.name_prefix}-http-monitor"
  pool_id     = openstack_lb_pool_v2.http.id
  type        = "TCP"
  timeout     = 1
  delay       = 1
  max_retries = 3
}

resource "openstack_lb_member_v2" "http" {
  for_each      = var.lb_members
  name          = each.key
  pool_id       = openstack_lb_pool_v2.http.id
  address       = each.value.internal_ip
  protocol_port = 80
}

resource "openstack_networking_floatingip_v2" "loadbalancer" {
  pool = var.floating_network
}

resource "openstack_networking_floatingip_associate_v2" "loadbalancer" {
  floating_ip = openstack_networking_floatingip_v2.loadbalancer.address
  port_id     = openstack_lb_loadbalancer_v2.loadbalancer.vip_port_id
}
