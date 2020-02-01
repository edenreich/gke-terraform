
terraform {
  backend "gcs" {
    bucket  = "eden-terraform"
    prefix  = "state"
    credentials = "/home/eden/.config/gcloud/account.json"
  }
}