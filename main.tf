
terraform {
  required_version = ">= 0.12.20"
}

provider "google" {
  version     = "~> 2.10"
  project     = "${var.project}"
  region      = "${var.region}"
  zone        = "${var.zone}"
}