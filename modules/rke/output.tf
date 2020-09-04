data "null_data_source" "rke_cluster" {
  inputs             = {
    api_server_url   = rke_cluster.cluster.api_server_url
    ca_cert          = rke_cluster.cluster.ca_crt
    client_cert      = rke_cluster.cluster.client_cert
    client_key       = rke_cluster.cluster.client_key
    kube_config_yaml = rke_cluster.cluster.kube_config_yaml
    rke_cluster_yaml = rke_cluster.cluster.rke_cluster_yaml
  }
}

output "rke_cluster" {
  value       = data.null_data_source.rke_cluster.outputs
  description = "RKE cluster spec"
}
