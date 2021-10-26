resource "google_compute_firewall" "allow_ssh" {
    name = "allow-ssh"
    network = "kubik"
    depends_on = [google_compute_subnetwork.public,]

    allow {
      protocol = "tcp"
      ports = ["22", "10250"]
    }

    target_tags = ["allow-ssh"]
  
}
resource "google_compute_firewall" "allow_icmp" {
    name = "allow-icmp"
    network = "kubik"
    depends_on = [google_compute_subnetwork.private,]

    allow {
      protocol = "icmp"
      #ports = ["25"]
    }

    target_tags = ["allow-icmp"]
  
}

resource "google_compute_firewall" "allow_ports" {
    name = "allow-master"
    network = "kubik"
    depends_on = [google_compute_subnetwork.public,]

    allow {
      protocol = "tcp"
      ports = ["443", "80", "10250", "6443", "2379", "2380", "10248", "10259", "10257"]
    }

    target_tags = ["allow-master"]
  
}