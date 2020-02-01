
terraform {
  backend "gcs" {
    bucket  = "eden-terraform"
    prefix  = "state"
  }
}