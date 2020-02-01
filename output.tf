
output "gcr_location" {
  value = "${data.google_container_registry_repository.foo.repository_url}"
}

output "cluster_endpoint" {
  value = "${google_container_cluster.primary.endpoint}"
}