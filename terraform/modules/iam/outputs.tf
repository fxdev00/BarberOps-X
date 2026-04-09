output "jenkins_sa_email" {
  description = "Jenkins service account email"
  value       = google_service_account.jenkins.email
}