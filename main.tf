module "keypair" {
  source       = "./modules/keypair"
  cluster_name = var.cluster_name
  ssh_key_file = var.ssh_key_file
}

module "network" {
  source          = "./modules/network"
  network_name    = "${var.cluster_name}-nodes-net"
  subnet_name     = "${var.cluster_name}-nodes-subnet"
  router_name     = "${var.cluster_name}-router"
  nodes_net_cidr  = var.nodes_net_cidr
  public_net_name = var.public_net_name
  dns_servers     = var.dns_servers
}

module "secgroup" {
  source       = "./modules/secgroup"
  name_prefix  = "${var.cluster_name}-master"
  rules        = var.secgroup_rules
}

module "master" {
  source             = "./modules/node"
  node_depends_on    = [module.network.nodes_subnet]
  name_prefix        = "${var.cluster_name}-master"
  nodes_count        = var.master_count
  image_name         = var.image_name
  flavor_name        = var.master_flavor_name
  keypair_name       = module.keypair.keypair_name
  network_name       = module.network.nodes_net_name
  secgroup_name      = module.secgroup.secgroup_name
  assign_floating_ip = "true" 
  floating_ip_pool   = var.public_net_name
}

module "edge" {
  source             = "./modules/node"
  node_depends_on    = [module.network.nodes_subnet]
  name_prefix        = "${var.cluster_name}-edge"
  nodes_count        = var.edge_count
  image_name         = var.image_name
  flavor_name        = var.worker_flavor_name
  keypair_name       = module.keypair.keypair_name
  network_name       = module.network.nodes_net_name
  secgroup_name      = module.secgroup.secgroup_name
  assign_floating_ip = "true" 
  floating_ip_pool   = var.public_net_name
}

module "worker" {
  source           = "./modules/node"
  node_depends_on  = [module.network.nodes_subnet]
  name_prefix      = "${var.cluster_name}-worker"
  nodes_count      = var.worker_count
  image_name       = var.image_name
  flavor_name      = var.worker_flavor_name
  keypair_name     = module.keypair.keypair_name
  network_name     = module.network.nodes_net_name
  secgroup_name    = module.secgroup.secgroup_name
  floating_ip_pool = var.public_net_name
}

module "rke" {
  source            = "./modules/rke"
  rke_depends_on    = [module.master.associate_floating_ip, module.network.router_interface, module.secgroup.secgroup_name]
  master_nodes      = module.master.nodes
  worker_nodes      = module.worker.nodes
  edge_nodes        = module.edge.nodes
  system_user       = var.system_user
  ssh_key_file      = var.ssh_key_file
  use_ssh_agent     = var.use_ssh_agent
  bastion_host      = var.bastion_host != null ? var.bastion_host : module.master.nodes[0].floating_ip
  os_auth_url       = var.os_auth_url
  os_password       = var.os_password
  master_labels     = var.master_labels
  edge_labels       = var.edge_labels
  worker_labels     = var.worker_labels
}
