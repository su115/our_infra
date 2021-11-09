
resource "google_compute_instance" "slave" {
  count        = var.instance-count
  name         = "slave-${count.index + 1}"
  machine_type = var.machine["slave"]
  depends_on   = [local.private-1]

  boot_disk {
    initialize_params {
      image = var.image
    }
  }
  tags = ["allow-private1-all", "allow-bastion-ssh", "allow-bastion-nodeport"]
  labels = {
    vm = "k8s-cluster"
  }
  desired_status = var.status-slaves

  ### GCE account
  allow_stopping_for_update = true
  service_account {
    email  = var.email
    scopes = ["cloud-platform"]
  }



  metadata = {
    ssh-keys = "debian:${file("cred/id_rsa.pub")}"
  }

  network_interface {
    subnetwork = "private-1"

  }
}


