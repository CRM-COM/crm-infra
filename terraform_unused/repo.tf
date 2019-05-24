resource "google_storage_bucket" "maven-repo" {
  name = "augnet-${var.environment}-repo"
  location = "EU"
}

data "google_container_registry_repository" "docker_repo" {

}

output "gcr_location" {
  value = "${data.google_container_registry_repository.docker_repo.repository_url}"
}