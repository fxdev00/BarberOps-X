
output "vpc_id" {
  description = "VPC ID used by GKE resources"
  value       = google_compute_network.vpc.id
}

output "subnet_id" {
  description = "SUBNET ID used by GKE resources"
  value       = google_compute_subnetwork.subnet.id
}