resource "openstack_compute_keypair_v2" "key" {
  name       = "${var.cluster_name}-key"
  public_key = file("${var.ssh_key_file}.pub")
}
