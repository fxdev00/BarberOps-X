output "cluster_name" {
  value = google_container_cluster.primary.name
}

output "cluster_endpoint" {
  value     = google_container_cluster.primary.endpoint
  sensitive = true
}

output "workload_pool" {
  description = "Used by IAM module for Workload Identity bindings"
  value       = "${var.project_id}.svc.id.goog"
}