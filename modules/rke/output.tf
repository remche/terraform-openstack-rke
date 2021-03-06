locals {
  rke_cluster = {
    api_server_url   = rke_cluster.cluster.api_server_url
    ca_crt           = rke_cluster.cluster.ca_crt
    client_cert      = rke_cluster.cluster.client_cert
    client_key       = rke_cluster.cluster.client_key
    kube_config_yaml = rke_cluster.cluster.kube_config_yaml
  }
}

output "rke_cluster" {
  value       = local.rke_cluster
  description = "RKE cluster spec"
  sensitive    = true
}
