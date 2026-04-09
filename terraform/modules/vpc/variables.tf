variable "project_id" {
  description = "Project ID"
  type        = string
}

variable "region" {
  description = "Region For All GCP Resources"
  type        = string
  default     = "europe-west2-"
}

variable "vpc_cidr" {
  description = "Primary CIDR For All GCP Resources"
  type        = string
  default     = "10.0.0.0/24"
}

variable "pods_cidr" {
  description = "Secondary CIDR For GKE Pods"
  type        = string
  default     = "10.1.0.0/24"
}

variable "services_cidr" {
  description = "Secondary CIDR For GKE Service"
  type        = string
  default     = "10.2.0.0/24"
}