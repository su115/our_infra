terraform {
  backend "gcs" {
    bucket      = "terraform-bucket-1511" 
    prefix      = "terraform/states/cluster/slaves"
    credentials = "cred/credterraform.json"
  }
}

