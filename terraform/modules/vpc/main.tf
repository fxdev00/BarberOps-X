# Custom VPC, auto_create_subnetworks = FALSE for granular control
resource "google_compute_network" "vpc" {
  name                    = "barberops-vpc"
  auto_create_subnetworks = false
  project                 = var.project_id
}

# Subnet One Per Region GKE Cluster Lives Here
resource "google_compute_subnetwork" "subnet" {
  name          = "barberops-subnet"
  ip_cidr_range = var.vpc_cidr
  region        = var.region
  network       = google_compute_network.vpc.id
  project       = var.project_id

  secondary_ip_range {
    range_name    = "pods"
    ip_cidr_range = var.pods_cidr
  }

  secondary_ip_range {
    range_name    = "services"
    ip_cidr_range = var.services_cidr
  }

  private_ip_google_access = true
}

# Cloud Router required for NAT
resource "google_compute_router" "router" {
  name    = "barberops-router"
  region  = var.region
  network = google_compute_network.vpc.id
  project = var.project_id
}

resource "google_compute_router_nat" "nat" {
  name                               = "barberops-nat"
  region                             = var.region
  router                             = google_compute_router.router.name
  project                            = var.project_id
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}