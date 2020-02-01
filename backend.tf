
terraform {
  backend "gcs" {
    bucket  = "gke-terraform-master"
    prefix  = "state"
  }
}
