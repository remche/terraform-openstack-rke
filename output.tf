output "keypair_name" {
  value = module.keypair.keypair_name
  description = "The name of the keypair used for nodes"
}

output "nodes_net_name" {
  value = module.network.nodes_net_name
  description = "The name of the nodes network"
}

output "master_floating_ips" {
  value = module.master.floating_ips
  description = "The floating ips of master nodes"
}
