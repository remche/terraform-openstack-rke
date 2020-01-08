module "keypair" {
  source = "./modules/keypair"
  cluster_name = var.cluster_name
  ssh_key_file = var.ssh_key_file
}

module "network" {
  source = "./modules/network"
  cluster_name = var.cluster_name
  nodes_net_cidr = var.nodes_net_cidr
  public_net_name = var.public_net_name
}

module "master" {
  source        = "./modules/node"
  cluster_name  = var.cluster_name
  name_prefix   = "${var.cluster_name}-master"
  nodes_count   = var.master_count
  image_name    = var.image_name
  flavor_name   = var.master_flavor_name
  keypair_name  = module.keypair.keypair_name
  network_name  = module.network.nodes_net_name
  secgroup_name = "default"
  assign_floating_ip = "true" 
  floating_ip_pool = var.public_net_name
}

module "worker" {
  source        = "./modules/node"
  cluster_name  = var.cluster_name
  name_prefix   = "${var.cluster_name}-worker"
  nodes_count   = var.worker_count
  image_name    = var.image_name
  flavor_name   = var.worker_flavor_name
  keypair_name  = module.keypair.keypair_name
  network_name  = module.network.nodes_net_name
  secgroup_name = "default"
  floating_ip_pool = var.public_net_name
}
