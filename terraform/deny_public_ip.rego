package gke.security

deny[msg] {
  some i
  input.resource_changes[i].type == "google_container_cluster"
  input.resource_changes[i].change.after.private_cluster_config.enable_private_nodes == false
  msg = sprintf("GKE cluster '%s' must have private nodes enabled.", [input.resource_changes[i].address])
}
