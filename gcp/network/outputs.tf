output "vpc" {
  value = google_compute_network.main_vpc
}

output "public-1" {
  value = google_compute_subnetwork.public-1
}
output "private-1" {
  value = google_compute_subnetwork.private-1
}

output "private-2" {
  value = google_compute_subnetwork.private-2
}


