resource "google_compute_firewall" "default" {
  name    = "web-firewall"
  network = "default"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = [ var.server_port ]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["web"]
}
