output "bastion-public-ip" {
  value = google_compute_instance.bastion[0].network_interface[0].access_config[0].nat_ip
}
output "bastion-private-ip" {
  value = google_compute_instance.bastion[0].network_interface[0].network_ip
}

