resource "google_compute_firewall" "allow_all_ssh" {
  name    = "allow-all-ssh"
  network = google_compute_network.main_vpc.name
  project = var.project_id
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  target_tags   = ["allow-all-ssh"]
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "allow_all_all" {
  name    = "allow-all-all"
  network = google_compute_network.main_vpc.name
  allow {
    protocol = "all"
    #"0-65535"
  }
  target_tags   = ["allow-all-all"]
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "allow_private1_all" {
  name    = "allow-private1-all"
  network = google_compute_network.main_vpc.name
  allow {
    protocol = "all"
  }
  target_tags   = ["allow-private1-all"]
  source_ranges = ["10.10.1.0/24"]
}

resource "google_compute_firewall" "allow_bastion_ssh" {
  name    = "allow-bastion-ssh"
  network = google_compute_network.main_vpc.name
  allow {
    protocol = "tcp"
    ports    = ["22", ]
  }
  target_tags   = ["allow-bastion-ssh"]
  source_ranges = ["10.10.2.2/32"]
}

resource "google_compute_firewall" "allow_bastion_nodeport" {
  name    = "allow-bastion-nodeport"
  network = google_compute_network.main_vpc.name
  allow {
    protocol = "tcp"
    ports    = ["30000-32768", ] # K8S Nodeport
  }
  target_tags   = ["allow-bastion-nodeport"]
  source_ranges = ["10.10.2.2/32"]
}

resource "google_compute_firewall" "allow_all_nodeport" {
  name    = "allow-all-nodeport"
  network = google_compute_network.main_vpc.name
  allow {
    protocol = "tcp"
    ports    = ["30000-32768", ] # K8S Nodeport
  }
  target_tags   = ["allow-bastion-nodeport"]
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "allow_bastion_6443" {
  name    = "allow-bastion-6443"
  network = google_compute_network.main_vpc.name
  allow {
    protocol = "tcp"
    ports    = ["6443", ] # K8S API server
  }
  target_tags   = ["allow-bastion-6443"]
  source_ranges = ["10.10.2.2/32"]
}

resource "google_compute_firewall" "allow_bastion_http" {
  name    = "allow-bastion-http"
  network = google_compute_network.main_vpc.name
  allow {
    protocol = "tcp"
    ports    = ["80", ] # K8S API server
  }
  target_tags   = ["allow-bastion-http"]
  source_ranges = ["10.10.2.2/32"]
}

resource "google_compute_firewall" "allow_private2_all" {
  name    = "allow-private2-all"
  network = google_compute_network.main_vpc.name
  allow {
    protocol = "all"
  }
  target_tags   = ["allow-private2-all"]
  source_ranges = ["10.10.3.0/24"]
}


