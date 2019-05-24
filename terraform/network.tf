resource "google_compute_network" "default" {
  name = "${var.project}-cluster-network"
  auto_create_subnetworks = "false"

}

resource "google_compute_subnetwork" "default" {
  name          = "${var.project}-cluster-subnet"
  network       = "${google_compute_network.default.self_link}"
  ip_cidr_range = "10.128.0.0/12"
  private_ip_google_access = "true"

  secondary_ip_range = {
    range_name    = "${var.project}-pods"
    ip_cidr_range = "10.144.0.0/12"
  }

  secondary_ip_range = {
    range_name    = "${var.project}-services"
    ip_cidr_range = "10.160.0.0/12"
  }
}

resource "google_compute_router" "router" {
  name    = "${var.project}-cluster-router"
  network = "${google_compute_network.default.self_link}"

}

resource "google_compute_router_nat" "cluster-nat" {
  name                               = "${var.project}-cluster-nat"
  router                             = "${google_compute_router.router.name}"
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetwork {
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
    name = "${google_compute_subnetwork.default.self_link}"
  }
}