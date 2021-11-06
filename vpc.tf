resource "google_compute_network" "main_vpc" {
  name = "kubik"
  auto_create_subnetworks = false # An option that does not allow you to create networks not in the described region.
}
#-------------------- S U B N E T S ----------------------------
resource "google_compute_subnetwork" "private" {
  name          = "private"
  ip_cidr_range = "10.10.1.0/24"
  region        = var.region
  network       = google_compute_network.main_vpc.id
  depends_on = [google_compute_network.main_vpc]
}

resource "google_compute_subnetwork" "public" {
  name          = "public"
  ip_cidr_range = "10.10.2.0/24"
  region        = var.region
  network       = google_compute_network.main_vpc.id
  depends_on = [google_compute_network.main_vpc]  # Dependence on the main network. It is created after main_vpc and is destroyed before it
}

# resource "google_compute_subnetwork" "db" {
#   name          = "db"
#   ip_cidr_range = "10.10.3.0/29"
#   region        = var.region
#   network       = google_compute_network.main_vpc.id
#   depends_on = [google_compute_network.main_vpc] # Dependence on the main network. It is created after main_vpc and is destroyed before it
# }
#-------------------- G A T E W A Y --------------------------------
resource "google_compute_router" "router" {
  name    = "my-router"
  region  = google_compute_subnetwork.private.region
  network = google_compute_network.main_vpc.id
  depends_on = [google_compute_subnetwork.private] # Dependence on a private network. It is created after it and is destroyed before it

  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "nat" {
  name                               = "my-router-nat"
  router                             = google_compute_router.router.name
  region                             = google_compute_router.router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  depends_on = [google_compute_router.router] # Dependence on the router
  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}