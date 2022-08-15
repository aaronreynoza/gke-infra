terraform {
  backend "gcs" {
    bucket  = "mario-test-terraform-state"
    prefix  = "terraform/state"
  }
}