
output "slaves-private-ips" {
  value = flatten( google_compute_instance.slave[*].network_interface[*].network_ip )
}

