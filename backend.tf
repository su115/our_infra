terraform {
  backend "gcs" {
    bucket  = "stone-botany-329514-bucket"
    prefix  = "terraform/state"
    credentials="credterraform.json"
  }
}