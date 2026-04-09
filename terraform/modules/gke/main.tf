

resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.region
  project  = var.project_id

  # Autopilot — Google manages nodes, I manage pods
  enable_autopilot = true
  network          = var.vpc_id
  subnetwork       = var.subnet_id

  # Use the secondary IP ranges I defined in the VPC module
  ip_allocation_policy {
    cluster_secondary_range_name  = "pods"
    services_secondary_range_name = "services"
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }

  # Workload Identity — pods authenticate to GCP using K8s service accounts
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }
  deletion_protection = false

}


