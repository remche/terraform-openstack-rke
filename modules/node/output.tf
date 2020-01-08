output "nodes" {
  value = data.null_data_source.nodes[*].outputs
}
