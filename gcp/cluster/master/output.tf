
output "master-private-ips" {
  value = flatten(google_compute_instance.master[*].network_interface[*].network_ip)
}

output "master1-private-ip" { # for ssh-tunnel and copy .kube/config
  value = flatten(google_compute_instance.master[0].network_interface[*].network_ip)
}
