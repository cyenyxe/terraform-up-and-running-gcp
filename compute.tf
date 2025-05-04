resource "google_compute_instance_template" "web_server" {
  name        = "web-server-template"
  description = "This template is used to create web server instances"

  tags         = ["web"]
  labels = {
    "chapter" = "2"
  }

  instance_description = "Web server instance"
  machine_type         = "e2-micro"
  can_ip_forward       = false

  metadata_startup_script = <<-EOF
    #!/bin/bash
    echo "hello world" > index.html
    nohup busybox httpd -f -p ${var.server_port} &
  EOF

  # allow_stopping_for_update = true

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  // Create a new boot disk from an image
  disk {
    source_image      = "ubuntu-os-cloud/ubuntu-2404-lts-amd64"
    auto_delete       = true
    boot              = true
    // backup the disk every day
    resource_policies = [google_compute_resource_policy.daily_backup.id]
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

resource "google_compute_resource_policy" "daily_backup" {
  name   = "every-day-4am"
  region = "europe-west1"
  snapshot_schedule_policy {
    schedule {
      daily_schedule {
        days_in_cycle = 1
        start_time    = "04:00"
      }
    }
  }
}

resource "google_compute_health_check" "auto_healing" {
  name                = "autohealing-health-check"
  check_interval_sec  = 5
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 10 # 50 seconds

  http_health_check {
    request_path = "/"
    port         = "8080"
  }
}

resource "google_compute_instance_group_manager" "web_server" {
  name = "web-server-igm"

  base_instance_name = "web-server"
  zone               = "europe-west1-b"

  version {
    instance_template  = google_compute_instance_template.web_server.self_link_unique
  }

  all_instances_config {
    labels = {
      "chapter" = "2"
    }
  }

  target_size  = var.instance_count

  named_port {
    name = "customhttp"
    port = 8888
  }

  auto_healing_policies {
    health_check      = google_compute_health_check.auto_healing.id
    initial_delay_sec = 300
  }
}