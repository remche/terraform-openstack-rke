output "keypair_name" {
  value = module.keypair.keypair_name
  description = "The name of the keypair used for nodes"
}

output "master_nodes" {
  value = module.master.nodes
  description = "The master nodes"
}

output "worker_nodes" {
  value = module.worker.nodes
  description = "The master nodes"
}
