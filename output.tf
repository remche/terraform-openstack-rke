output "keypair_name" {
  value       = module.keypair.keypair_name
  description = "The name of the keypair used for nodes"
  sensitive   = "true"
}

output "master_nodes" {
  value       = module.master.nodes
  description = "The master nodes"
  sensitive   = "true"
}

output "edge_nodes" {
  value       = module.edge.nodes
  description = "The edge nodes"
  sensitive   = "true"
}

output "worker_nodes" {
  value       = module.worker.nodes
  description = "The worker nodes"
  sensitive   = "true"
}

output "rke_cluster" {
  value       = module.rke.rke_cluster
  description = "RKE cluster spec"
  sensitive   = "true"
}

output "nodes_subnet" {
  value       = module.network.nodes_subnet
  description = "The nodes subnet"
  sensitive   = "true"
}

output "loadbalancer_floating_ip" {
  value       = var.enable_loadbalancer ? module.loadbalancer[0].floating_ip : ""
  description = "The floating ip of the loadbalancer"
  sensitive   = "true"
}
