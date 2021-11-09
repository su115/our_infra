output "vpc" {
  value = google_compute_network.main_vpc.self_link
}

output "public-1" {
  value = google_compute_subnetwork.public-1.self_link
}
output "private-1" {
  value = google_compute_subnetwork.private-1.self_link
}

output "private-2" {
  value = google_compute_subnetwork.private-2.self_link
}


