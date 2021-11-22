output "gitlab-private-ip" { # for ssh-tunnel and copy .kube/config
  value = flatten(google_compute_instance.gitlab[0].network_interface[*].network_ip)
}
