terraform {
  backend "gcs" {
    bucket  = "terraform6bucket123"
    prefix  = "terraform/state"
    credentials="credterraform-test.json"
  }
}
