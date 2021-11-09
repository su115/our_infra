#-------------------- M A S T E R -----------------------------------

resource "google_compute_instance" "master" {
 count = var.master-count
 machine_type = var.machine["master"]
 name = "master-${count.index+1}"

### GCE account
allow_stopping_for_update = true
service_account {
	email=var.email
	scopes = ["cloud-platform"]
}


 boot_disk {
    initialize_params {image = var.image}
 }
  depends_on = [local.private-1]
  metadata = {ssh-keys = "debian:${file("cred/id_rsa.pub")}"}
  tags = ["allow-bastion-nodeport", "allow-bastion-ssh","allow-private1-all"]
  network_interface {
     subnetwork = local.private-1

  }
}

