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
