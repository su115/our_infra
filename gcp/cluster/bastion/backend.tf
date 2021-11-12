terraform {
  backend "gcs" {
    bucket	= "terraform-bucket-1712"
    prefix      = "terraform/states/cluster/bastion" # Important !!!
    credentials = "cred/credterraform.json"
  }
}

