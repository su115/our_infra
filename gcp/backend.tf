terraform {
  backend "gcs" {
    bucket      = "terraform-bucket-1511" 
    prefix      = "terraform/states/cluster/master"
    credentials = "cred/credterraform.json"
  }
}

