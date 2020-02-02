
terraform {
  backend "gcs" {
    bucket  = "gke-terraform-acme"
    prefix  = "state"
  }
}
