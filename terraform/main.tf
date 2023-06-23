data "google_container_registry_image" "cohort_image" {
  project  = var.project
  name     = "cohort"
  tag      = var.image_tag
}

resource "google_cloud_run_service" "cohort_service" {
  name     = "cohort-service"
  location = var.region

  template {
    spec {
      containers {
        image = data.google_container_registry_image.cohort_image.image_url
      }
      service_account_name = "sa-cohort@cohort-389109.iam.gserviceaccount.com"
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

