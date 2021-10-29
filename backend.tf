terraform {
  backend "gcs" {
    bucket  = "stone-botany-test"
    prefix  = "terraform/state"
    credentials="credterraform.json"
  }
}
