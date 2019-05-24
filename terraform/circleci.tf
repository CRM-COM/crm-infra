resource "google_service_account" "circleci" {
  account_id = "circleci"
  display_name = "Circle CI builder"
}

resource "google_project_iam_member" "circleci-k8s" {
  member = "serviceAccount:${google_service_account.circleci.email}"
  role = "roles/container.admin"
}

resource "google_project_iam_member" "circleci-storage" {
  member = "serviceAccount:${google_service_account.circleci.email}"
  role = "roles/storage.objectAdmin"
}

resource "google_project_iam_member" "circleci-gcr" {
  member = "serviceAccount:${google_service_account.circleci.email}"
  role = "roles/storage.admin"
}

resource "google_service_account_key" "circleci" {
  service_account_id = "${google_service_account.circleci.name}"

}

output "circleci_key" {
  value = "${google_service_account_key.circleci.private_key}"
  sensitive = true
}