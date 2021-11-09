
resource "google_compute_instance" "bastion" {
  count        = "1"
  machine_type = var.machine["bastion"]
  name         = "bastion"

  boot_disk {
    initialize_params { image = var.image }
  }

  tags    = ["allow-all-ssh", ]
  project = var.project_id
  zone    = var.zone
  metadata = {
    ssh-keys = "debian:${file("cred/id_rsa.pub")}"
  }
  desired_status = var.status-bastion
  depends_on     = [local.public-1]
  network_interface {
    subnetwork = local.public-1

    access_config {
      // Include this section to give the VM an external ip address
    }
  }
}

