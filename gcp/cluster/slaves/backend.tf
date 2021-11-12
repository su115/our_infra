terraform {
  backend "gcs" {
    bucket	= "terraform-bucket-1712"
    prefix      = "terraform/states/cluster/slaves"
    credentials = "cred/credterraform.json"
  }
}

