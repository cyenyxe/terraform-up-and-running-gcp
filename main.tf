provider "google" {
  project = "cristina-yenyxe-sandbox"
  region  = "europe-west1"
  zone    = "europe-west1-b"
}

resource "google_service_account" "default" {
  account_id   = "vm-instance-sa"
  display_name = "Custom SA for web server VM instance"
}

