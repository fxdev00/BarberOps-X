terraform {
  required_version = ">= 1.6"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# ── Step 1: Networking ──────────────────────────────────────────
module "vpc" {
  source     = "../../modules/vpc"
  project_id = var.project_id
  region     = var.region
}

# ── Step 2: Container Registry ──────────────────────────────────
module "artifact_registry" {
  source     = "../../modules/artifact-registry"
  project_id = var.project_id
  region     = var.region
}

# ── Step 3: GKE Cluster ─────────────────────────────────────────
module "gke" {
  source     = "../../modules/gke"
  project_id = var.project_id
  region     = var.region
  vpc_id     = module.vpc.vpc_id
  subnet_id  = module.vpc.subnet_id
}

# ── Step 4: IAM ─────────────────────────────────────────────────
module "iam" {
  source     = "../../modules/iam"
  project_id = var.project_id
  depends_on = [module.gke]
}