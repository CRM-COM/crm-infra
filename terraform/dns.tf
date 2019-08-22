resource "google_dns_managed_zone" "main_zone" {
  name = "${var.environment}-zone"
  dns_name = "${var.domain}."
}

resource "google_compute_global_address" "api" {
  name     = "gateway-static-ip"
}

resource "google_compute_global_address" "keycloak" {
  name     = "keycloak-static-ip"
}

resource "google_compute_global_address" "dashboard" {
  name     = "dashboard-static-ip"
}

resource "google_compute_global_address" "swagger" {
  name     = "swagger-static-ip"
}

resource "google_compute_global_address" "spectacle" {
  name     = "spectacle-static-ip"
}

resource "google_dns_record_set" "api" {
  name         = "dev.${google_dns_managed_zone.main_zone.dns_name}"
  type         = "A"
  ttl          = 6000
  managed_zone = "${google_dns_managed_zone.main_zone.name}"
  rrdatas      = ["${google_compute_global_address.api.address}"]
}

resource "google_dns_record_set" "keycloak" {
  name         = "keycloak.${google_dns_managed_zone.main_zone.dns_name}"
  type         = "A"
  ttl          = 300
  managed_zone = "${google_dns_managed_zone.main_zone.name}"
  rrdatas      = ["${google_compute_global_address.keycloak.address}"]
}

resource "google_dns_record_set" "dashboard" {
  name         = "dashboard.${google_dns_managed_zone.main_zone.dns_name}"
  type         = "A"
  ttl          = 300
  managed_zone = "${google_dns_managed_zone.main_zone.name}"
  rrdatas      = ["${google_compute_global_address.dashboard.address}"]
}


resource "google_dns_record_set" "swagger" {
  name         = "swagger.${google_dns_managed_zone.main_zone.dns_name}"
  type         = "A"
  ttl          = 300
  managed_zone = "${google_dns_managed_zone.main_zone.name}"
  rrdatas      = ["${google_compute_global_address.swagger.address}"]

}

/*
resource "google_dns_record_set" "redis" {
  name         = "redis.${google_dns_managed_zone.main_zone.dns_name}"
  type         = "A"
  ttl          = 300
  managed_zone = "${google_dns_managed_zone.main_zone.name}"
  rrdatas      = ["${google_redis_instance.main-cache.host}"]
}

*/
resource "google_dns_record_set" "db" {
  name         = "db.${google_dns_managed_zone.main_zone.dns_name}"
  type         = "A"
  ttl          = 300
  managed_zone = "${google_dns_managed_zone.main_zone.name}"
  rrdatas      = ["${google_sql_database_instance.main_sql.first_ip_address}"]
}

output "dns_nameservers" {
  value = "${google_dns_managed_zone.main_zone.name_servers}"
}


output "api_ip_name" {
  value = "${google_compute_global_address.api.name}"
}

output "api_ip_address" {
  value = "${google_compute_global_address.api.address}"
}

output "keycloak_ip_name" {
  value = "${google_compute_global_address.keycloak.name}"
}

output "keycloak_ip_address" {
  value = "${google_compute_global_address.keycloak.address}"
}

output "dashboard_ip_name" {
  value = "${google_compute_global_address.dashboard.name}"
}

output "dashboard_ip_address" {
  value = "${google_compute_global_address.dashboard.address}"
}