terraform {
  backend "gcs" {
    bucket	= "terraform-bucket-1712"
    prefix      = "terraform/states/gitlab"
    credentials = "cred/credterraform.json"
  }
}

