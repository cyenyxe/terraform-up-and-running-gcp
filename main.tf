provider "google" {
  project = "cristina-yenyxe-sandbox"
  region  = "europe-west1"
  zone    = "europe-west1-b"
}

resource "google_service_account" "default" {
  account_id   = "vm-instance-sa"
  display_name = "Custom SA for web server VM instance"
}

resource "google_compute_instance" "default" {
  name         = "web-server"
  machine_type = "e2-micro"
  tags         = ["web"]
  labels = {
    "chapter" = "2"
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    echo "hello world" > index.html
    nohup busybox httpd -f -p ${var.server_port} &
  EOF

  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2404-lts-amd64"
      labels = {
        sample-label = "sample-value"
      }
    }
  }

  network_interface {
    network = "default"

    access_config {

    }
  }

  service_account {
    email  = google_service_account.default.email
    scopes = ["cloud-platform"]
  }
}
