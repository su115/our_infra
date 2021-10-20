provider "google" {
	project = "stone-botany-329514"
	region = "us-central1"
	zone = "us-central1-c"
	credentials=file("stone-botany-329514-60abc263d199.json")
}

// Terraform plugin for creating random ids
resource "random_id" "instance_id" {
 byte_length = 8
}

// A single Compute Engine instance
resource "google_compute_instance" "master" {
 name         = "master-vm-${random_id.instance_id.hex}"
 machine_type = "n2d-highcpu-2"
 zone         = "us-west1-a"

# Status machine
 desired_status = "RUNNING"
# desired_status = "STOPPED"

 boot_disk {
   initialize_params {
     image = "ubuntu-1804-bionic-v20200807"
   }
 }
 metadata = {
   ssh-keys = "debian:${file("./gcp_main.pub")}"
 }


// Make sure flask is installed on all new instances for later steps
# metadata_startup_script = "sudo apt-get update; sudo apt-get install -yq build-essential python-pip rsync; pip install flask"

 network_interface {
   network = "default"

   access_config {
     // Include this section to give the VM an external ip address
   }
 }
}

## -------------- Slaves -----------------
// A single Compute Engine instance
resource "google_compute_instance" "slave1" {
 name         = "slave1-vm-${random_id.instance_id.hex}"
 machine_type = "n2d-highcpu-2"
 zone         = "us-west1-a"

# Status machine
 desired_status = "RUNNING"
# desired_status = "STOPPED"

 boot_disk {
   initialize_params {
     image = "ubuntu-1804-bionic-v20200807"
   }
 }
 metadata = {
   ssh-keys = "debian:${file("./gcp_main.pub")}"
 }


// Make sure flask is installed on all new instances for later steps
 # metadata_startup_script = "sudo apt-get update; sudo apt-get install -yq build-essential python-pip rsync; pip install flask"

 network_interface {
   network = "default"

 #  access_config {
 #    // Include this section to give the VM an external ip address
 #  }
 }
}

// A single Compute Engine instance
resource "google_compute_instance" "slave2" {
 name         = "slave2-vm-${random_id.instance_id.hex}"
 machine_type = "n2d-highcpu-2"
 zone         = "us-west1-a"


# Status machine
 desired_status = "RUNNING"
# desired_status = "STOPPED"



 boot_disk {
   initialize_params {
     image = "ubuntu-1804-bionic-v20200807"
   }
 }
 metadata = {
   ssh-keys = "debian:${file("./gcp_main.pub")}"
 }


// Make sure flask is installed on all new instances for later steps
 # metadata_startup_script = "sudo apt-get update; sudo apt-get install -yq build-essential python-pip rsync; pip install flask"

 network_interface {
   network = "default"

 #  access_config {
 #    // Include this section to give the VM an external ip address
 #  }
 }
}

// A variable for extracting the external IP address of the instance
output "ip1" {
 value = google_compute_instance.master.network_interface.0.access_config.0.nat_ip
}

output "master1"{
 value = google_compute_instance.master.network_interface.0.network_ip
}



output "slave1"{
 value = google_compute_instance.slave1.network_interface.0.network_ip
}



output "slave2"{
 value = google_compute_instance.slave2.network_interface.0.network_ip
}




resource "google_compute_firewall" "master" {
 name    = "flask-app-firewall"
 network = "default"

 allow {
   protocol = "tcp"
   ports    = ["5000"]
 }
}


