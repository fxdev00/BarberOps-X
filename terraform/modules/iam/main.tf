# GCP service account that Jenkins will impersonate
resource "google_service_account" "jenkins" {
  project      = var.project_id
  account_id   = "jenkins-sa"
  display_name = "Jenkins — Artifact Registry push access"
}

# Give it permission to push/pull images in Artifact Registry
resource "google_project_iam_member" "jenkins_registry" {
  project = var.project_id
  role    = "roles/artifactregistry.writer"
  member  = "serviceAccount:${google_service_account.jenkins.email}"
}

# Workload Identity binding
# K8s service account jenkins/jenkins can act as the GCP service account above
resource "google_service_account_iam_member" "jenkins_workload_identity" {
  service_account_id = google_service_account.jenkins.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[jenkins/jenkins]"
}