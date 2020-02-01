
resource "google_container_cluster" "primary" {
  name     = "${var.cluster_name}"
  location = "${var.region}"

  initial_node_count = "${var.initial_node_count}"

  master_auth {
    username = "${var.master_node_username}"
    password = "${var.master_node_password}"

    client_certificate_config {
      issue_client_certificate = false
    }
  }
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "${var.cluster_name}-pool"
  location   = "${var.region}"
  cluster    = "${google_container_cluster.primary.name}"
  node_count = "${var.node_count}"

  node_config {
    preemptible  = true
    machine_type = "n1-standard-1"

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    tags = ["k8s-${var.cluster_name}-${var.environment}"]
  }
}
