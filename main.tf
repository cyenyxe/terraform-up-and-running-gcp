provider "google" {
  project = "cristina-yenyxe-sandbox"
  region  = "us-central1"
  zone    = "us-central1-a"
}

resource "google_service_account" "default" {
  account_id   = "vm-instance-sa"
  display_name = "Custom SA for VM instance"
}

resource "google_compute_instance" "default" {
  name         = "vm-instance"
  machine_type = "e2-micro"
  labels = {
    "chapter" = "2"
  }

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      labels = {
        sample-label = "sample-value"
      }
    }
  }

  network_interface {
    network = "default"
  }
}
