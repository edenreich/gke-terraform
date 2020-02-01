
terraform {
  backend "gcs" {
    bucket  = "gke-terraform-staging"
    prefix  = "state"
  }
}
