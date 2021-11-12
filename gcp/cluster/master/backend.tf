terraform {
  backend "gcs" {
    bucket	= "terraform-bucket-1712"
    prefix      = "terraform/states/cluster/master"
    credentials = "cred/credterraform.json"
  }
}

