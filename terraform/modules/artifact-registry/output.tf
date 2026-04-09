output "registry_url" {
  description = "Full registry URL for docker push/pull commands"
  value       = "${var.region}-docker.pkg.dev/${var.project_id}/${var.repository_id}"
}