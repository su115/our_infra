

provider "google" {
  project = "stone-botany-329514"
	region = var.region
	zone = var.zone
	credentials=file("credterraform.json")
  
}


#-------------------- M A S T E R -----------------------------------

resource "google_compute_instance" "master" {
 count = var.master_count
 machine_type = var.machine["master"]
 name = "master-${count.index+1}"

### GCE account
allow_stopping_for_update = true
service_account {
	email="k8s-gce-test@stone-botany-329514.iam.gserviceaccount.com"
	scopes = ["cloud-platform"]
}


 boot_disk {
    initialize_params {image = var.image}
 }
  depends_on = [google_compute_subnetwork.private]
  metadata = {ssh-keys = "debian:${file("./id_rsa.pub")}"}
  tags = ["allow-icmp", "allow-ssh", "allow-all"]
  network_interface {
     subnetwork = "private"

  }
}

#---------------------- S L A V E S ------------------------------------

resource "google_compute_instance" "slave" {
 count = var.instance_count
 name         = "slave-${count.index+1}"
 machine_type = var.machine["slave"]
 depends_on = [google_compute_subnetwork.private]
 
 boot_disk {
   initialize_params {
     image = var.image
   }
 }
 tags = ["allow-icmp", "allow-ssh", "allow-all"]
# labels = {
#   name = "Slave-${count.index+1}"
#   machine_type = "${var.environment == "prod" ? var.machine_type : var.machine_type_dev}"
# }


### GCE account
allow_stopping_for_update = true
service_account {
	email="k8s-gce-test@stone-botany-329514.iam.gserviceaccount.com"
	scopes = ["cloud-platform"]
}



 metadata = {
  ssh-keys = "debian:${file("./id_rsa.pub")}"
}
 
 network_interface {
   subnetwork = "private"
 
 }
}

#------------------ B A S T I O N -----------------------------------

resource "google_compute_instance" "bastion" {
count = "1"
 machine_type = var.machine["bastion"]
 name = "bastion" 
 #machine_type = "${var.environment != "dev" ? var.machine_type : var.machine_type_dev}"
 
 boot_disk {
    initialize_params {image = var.image}
 }

tags = ["allow-icmp", "allow-ssh"]

  metadata = {
   ssh-keys = "debian:${file("./id_rsa.pub")}"
 }

metadata_startup_script = "sudo chmod 600 /home/debian/.ssh/id_rsa.pub" # Міняти ТУТ


#  service_account {
#    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
#  }
 depends_on = [google_compute_subnetwork.public]
 network_interface {
   subnetwork = "public"

   access_config {
     // Include this section to give the VM an external ip address

   }
 }
}
##------------------------- D A T A B A S E ------------------------------
#
#resource "google_compute_instance" "db" {
# count = var.db_count
# machine_type = var.machine["db"]
# name = "db-${count.index+1}"
# depends_on = [google_compute_subnetwork.db]
# 
# boot_disk {
#    initialize_params {image = var.image}
# }
#
#  metadata = {
#   ssh-keys = "db:${file("./id_rsa.pub")}"
# }
# tags = ["allow-icmp", "allow-ssh", "allow-all"]
# network_interface {
#   subnetwork = "db"
#
#  }
#}
