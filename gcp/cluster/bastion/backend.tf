terraform {
  backend "gcs" {
    bucket      = "terraform-bucket-1511"
    prefix      = "terraform/states/cluster/bastion" # Important !!!
    credentials = "cred/credterraform.json"
  }
}

