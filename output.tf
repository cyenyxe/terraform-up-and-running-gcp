output "public_ip" {
    description = "Public IP of the web server"
    value = google_compute_instance.default.network_interface.0.access_config.0.nat_ip
}

output "private_ip" {
    description = "Private IP of the web server"
    value = google_compute_instance.default.network_interface.0.network_ip
}