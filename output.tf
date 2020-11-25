output "keypair_name" {
  value       = module.keypair.keypair_name
  description = "The name of the keypair used for nodes"
}

output "master_nodes" {
  value       = module.master.nodes
  description = "The master nodes"
}

output "edge_nodes" {
  value       = module.edge.nodes
  description = "The edge nodes"
}

output "worker_nodes" {
  value       = module.worker.nodes
  description = "The worker nodes"
}

output "rke_cluster" {
  value       = module.rke.rke_cluster
  description = "RKE cluster spec"
  sensitive   = "true"
}

output "nodes_subnet" {
  value       = module.network.nodes_subnet
  description = "The nodes subnet"
}

output "loadbalancer_floating_ip" {
  value       = var.enable_loadbalancer ? module.loadbalancer.floating_ip : ""
  description = "The floating ip of the loadbalancer"
}
