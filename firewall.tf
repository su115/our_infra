resource "google_compute_firewall" "allow_ssh" {  # Allow SSH
    name = "allow-ssh"
    network = "kubik"
    depends_on = [google_compute_subnetwork.public,]

    allow {
      protocol = "tcp"
      ports = ["22", "10250"]
    }

    target_tags = ["allow-ssh"]
  
}
resource "google_compute_firewall" "allow_icmp" {   # Allow ping
    name = "allow-icmp"
    network = "kubik"
    depends_on = [google_compute_subnetwork.private,]

    allow {
      protocol = "icmp"
      #ports = ["25"]
    }

    target_tags = ["allow-icmp"]
  
}

resource "google_compute_firewall" "allow_all_protocols" {   # Allowing all protocols and ports
    name = "allow-all"
    network = "kubik"
    depends_on = [google_compute_subnetwork.public,]

    allow {
      protocol = "all"
      #ports = ["all",]
    }

    target_tags = ["allow-all"]
  
}

#Elastic search, stek elk
