output "cluster_name" {
  value = module.gke.cluster_name
}

output "registry_url" {
  value = module.artifact_registry.registry_url
}

output "jenkins_sa_email" {
  value = module.iam.jenkins_sa_email
}