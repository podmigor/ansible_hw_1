output "ansible-runner-ip" {
  value = google_compute_address.static.address
}