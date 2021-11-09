
output "master-private-ip" {
  value = google_compute_instance.master[0].network_interface[0].network_ip
}

