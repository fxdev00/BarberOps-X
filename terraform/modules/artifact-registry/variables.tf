variable "project_id" {
  description = "Project ID"
  type        = string
}

variable "region" {
  description = "Region For All GCP Resources"
  type        = string
  default     = "europe-west2"
}

variable "repository_id" {
  description = "Repository Name"
  type        = string
  default     = "barberops"
}

variable "format" {
  description = "Repository Format Value"
  type        = string
  default     = "DOCKER"
}