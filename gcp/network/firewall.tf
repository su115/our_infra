resource "google_compute_firewall" "allow_all_ssh" {  # Allow SSH
    name = "allow-all-ssh"
    network = google_compute_network.main_vpc.name
###    depends_on = [google_compute_subnetwork.public-1,]
    project = var.project_id
    allow {
      protocol = "tcp"
      ports = ["22"]
    }
    
    target_tags = ["allow-all-ssh"]
 source_ranges=["0.0.0.0/0"] 
}
resource "google_compute_firewall" "allow_all_icmp" {   # Allow ping
    name = "allow-all-icmp"
    network =  google_compute_network.main_vpc.name

### depends_on = [google_compute_subnetwork.private,]

    allow {
      protocol = "icmp"
      
    }

    target_tags = ["allow-all-icmp"]
    source_ranges=["0.0.0.0/0"]  
}

resource "google_compute_firewall" "allow_all_all" {   # Allowing all protocols and ports
    name = "allow-all-all"
    network =  google_compute_network.main_vpc.name

###    depends_on = [google_compute_subnetwork.public,]

    allow {
      protocol = "all"
#      ports = ["0-65535",]
    }

    target_tags = ["allow-all-all"]
    source_ranges=["0.0.0.0/0"]  
}
resource "google_compute_firewall" "allow_private1_all" {   # Allowing all protocols and ports
    name = "allow-private1-all"
    network =  google_compute_network.main_vpc.name

###    depends_on = [google_compute_subnetwork.public,]

    allow {
      protocol = "all"
 #     ports = ["0-65535",]
    }

    target_tags = ["allow-private1-all"]
    source_ranges=["10.10.1.0/24"]  
}
resource "google_compute_firewall" "allow_bastion_ssh" {   # Allowing all protocols and ports
    name = "allow-bastion-ssh"
    network =  google_compute_network.main_vpc.name

###    depends_on = [google_compute_subnetwork.public,]

    allow {
      protocol = "tcp"
      ports = ["22",]
    }

    target_tags = ["allow-bastion-ssh"]
    source_ranges=["10.10.2.2/32"]  
}

resource "google_compute_firewall" "allow_bastion_nodeport" {   # Allowing all protocols and ports
    name = "allow-bastion-nodeport"
    network =  google_compute_network.main_vpc.name


    allow {
      protocol = "tcp"
      ports = ["30000-32768",] # K8S Nodeport
    }

    target_tags = ["allow-bastion-nodeport"]
    source_ranges=["10.10.2.2/32"]  
}






#Elastic search, stek elk
