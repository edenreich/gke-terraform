
terraform {
  backend "gcs" {
    bucket  = "gke-terraform"
    prefix  = "state"
  }
}
