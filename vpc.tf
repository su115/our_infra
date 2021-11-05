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
}

resource "google_compute_subnetwork" "public" {
  name          = "public"
  ip_cidr_range = "10.10.2.0/24"
  region        = var.region
  network       = google_compute_network.main_vpc.id
}

resource "google_compute_subnetwork" "db" {
  name          = "db"
  ip_cidr_range = "10.10.3.0/29"
  region        = var.region
  network       = google_compute_network.main_vpc.id
}
#-------------------- G A T E W A Y --------------------------------
resource "google_compute_router" "router" {
  name    = "my-router"
  region  = google_compute_subnetwork.private.region
  network = google_compute_network.main_vpc.id

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
  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}
