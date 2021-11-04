terraform {
  backend "gcs" {
    bucket  = "stone-botany-ihor" # manualy create
    prefix  = "terraform/state"
    credentials="credterraform.json"
  }
}
