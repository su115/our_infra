terraform {
  backend "gcs" {
    bucket	= "terraform-bucket-1712"
    prefix      = "terraform/states/network"
    credentials = "cred/credterraform.json"
  }
}

