
output "master-private-ip" {
  value = flatten(google_compute_instance.master[*].network_interface[*].network_ip)
}

