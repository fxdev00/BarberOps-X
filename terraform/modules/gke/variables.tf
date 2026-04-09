variable "project_id" {
  description = "value"
  type        = string
}

variable "region" {
  description = "value"
  type        = string
}

variable "vpc_id" {
  description = "value"
  type        = string
}

variable "subnet_id" {
  description = "value"
  type        = string
}

variable "cluster_name" {
  description = "Name of the GKE cluster"
  type        = string
  default     = "barberops-cluster"
}