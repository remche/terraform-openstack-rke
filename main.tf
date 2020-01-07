module "keypair" {
  source = "./modules/keypair"
  cluster_name = var.cluster_name
}

module "network" {
  source = "./modules/network"
  cluster_name = var.cluster_name
}
