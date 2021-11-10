output "bastion-public-ip" {
  value = google_compute_instance.bastion[0].network_interface[0].access_config[0].nat_ip
}
output "bastion-private-ips" {
  value = flatten( google_compute_instance.bastion[*].network_interface[*].network_ip )
}

