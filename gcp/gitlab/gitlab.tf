#-------------------- M A S T E R -----------------------------------

resource "google_compute_instance" "gitlab" {
  count        = 1
  machine_type = var.machine["gitlab"]
  name         = "gitlab"

  ### GCE account
  allow_stopping_for_update = true
  service_account {
    email  = var.email
    scopes = ["cloud-platform"]
  }
  labels = {
    vm = "gitlab"
  }
  desired_status = var.status-gitlab
  boot_disk {
    initialize_params { image = var.image }
  }
  depends_on = [local.private-2]
  metadata   = { ssh-keys = "debian:${file("cred/id_rsa.pub")}" }
  tags       = ["allow-bastion-http","allow-bastion-ssh", "allow-private1-all"]
  network_interface {
    subnetwork = local.private-2

  }
}

