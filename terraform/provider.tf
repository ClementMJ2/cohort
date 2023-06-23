provider "google" {
  credentials = file(var.service_account_key)
  project     = var.project
  region      = var.region
}
