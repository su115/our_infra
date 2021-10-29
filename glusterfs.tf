#
# provider "google" {
#  project = "stone-botany-329514"
#	region = var.region
#	zone = var.zone
#	credentials=file("credterraform.json")
#  
# }
#------------------------- D A T A B A S E ------------------------------

resource "google_compute_instance" "db" {
  count        = var.db_count
  machine_type = var.machine["db"]
  name         = "db-${count.index + 1}"
  depends_on   = [google_compute_subnetwork.db]

  boot_disk {
    initialize_params { image = var.image }
  }
  allow_stopping_for_update = true # help debug
  # disk {
  #	auto_delete = true
  #	type = "pd-standard"
  #	disk_size_gb=50
  # }
  metadata = {
   ssh-keys = "db:${file("./id_rsa.pub")}"
 }
 tags = ["allow-icmp", "allow-ssh", "allow-all"]
 network_interface {
   subnetwork = "db"
  }
}

##--------------------------- Disk -------------------------------
resource "google_compute_attached_disk" "attach_db1" {
  disk     = google_compute_disk.d50_1.id
  instance = google_compute_instance.db[0].id
}
resource "google_compute_attached_disk" "attach_db2" {
  disk     = google_compute_disk.d50_2.id
  instance = google_compute_instance.db[1].id
}
resource "google_compute_disk" "d50_2" {
#  count = var.db_count
  name  = "disk-50g-1"
  type  = "pd-standard"
  size  = 50
}
resource "google_compute_disk" "d50_1" {
#  count = var.db_count
  name  = "disk-50g-2"
  type  = "pd-standard"
  size  = 50
}



##--------------------------- Disk -------------------------------

output "DB-glusterfs-1" {
  value = google_compute_instance.db[0].network_interface[0].network_ip
}
output "DB-glusterfs-2" {
  value = google_compute_instance.db[1].network_interface[0].network_ip
}
