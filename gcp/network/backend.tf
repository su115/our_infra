terraform {
  backend "gcs" {
    bucket      = "terraform-bucket-1511"
    prefix      = "terraform/states/network"
    credentials = "cred/credterraform.json"
  }
}

