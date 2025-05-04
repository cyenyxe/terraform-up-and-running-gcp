data "google_compute_instance_group" "mig_web_server" {
  self_link = google_compute_instance_group_manager.web_server.instance_group
}

output instance_group {
  description = "Link to the `instance_group` property of the instance group manager resource."
  value       = data.google_compute_instance_group.mig_web_server
}

output instances {
  # Getting the most updated information may require running `terraform refresh` after `terraform apply`
  description = "List of instances in the instance group - can change dynamically depending on the current number of instances, and may be empty the first time read."
  value       = data.google_compute_instance_group.mig_web_server.*.instances
}
