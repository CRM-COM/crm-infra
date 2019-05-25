resource "google_container_cluster" "main" {
  name = "${var.project}-cluster"
  zone   = "${var.zone}"
  network    = "${google_compute_network.default.name}"
  subnetwork = "${google_compute_subnetwork.default.name}"
  initial_node_count = 1

  min_master_version = "${var.gke_version}"

  master_auth {
    username = "k8admin"
    password = "${random_string.k8s-master-password.result}"
  }
  remove_default_node_pool = true

  enable_legacy_abac = false
  enable_kubernetes_alpha = false
  addons_config {
    horizontal_pod_autoscaling {
      disabled = false
    }
    http_load_balancing {
      disabled = false
    }
    kubernetes_dashboard {
      disabled = false
    }
    network_policy_config {
      disabled = false
    }


  }



  ip_allocation_policy {
    cluster_secondary_range_name  = "${var.project}-pods"
    services_secondary_range_name = "${var.project}-services"
  }

  private_cluster_config {
    enable_private_nodes   = true
    master_ipv4_cidr_block = "10.255.255.224/28"
  }

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block = "0.0.0.0/0"
      display_name = "ALL"
    }
  }
  network_policy {
    enabled = true
    provider = "CALICO"
  }


  lifecycle {
    ignore_changes = [ "master_auth.0.client_certificate_config", "network", "subnetwork"]
  }
}

resource "google_container_node_pool" "main_pool" {
  cluster = "${google_container_cluster.main.name}"
  zone   = "${var.zone}"

  node_count = 2
//  autoscaling {
//    max_node_count = "${var.max_nodes}"
//    min_node_count = "${var.min_nodes}"
//
//  }
  name = "main-pool"
  management {
    auto_repair = true
    auto_upgrade = true
  }

  node_config {
    machine_type = "${var.gke_node_type}"
    preemptible = false
    metadata {
      disable-legacy-endpoints = "true"
    }
    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
  lifecycle {
    ignore_changes = ["node_count"]
  }
}

resource "random_string" "k8s-master-password" {
  length = 16
}

resource "kubernetes_namespace" "infra" {
  "metadata" {
    name = "infra"
  }
}


resource "kubernetes_namespace" "backend" {
  "metadata" {
    name = "backend"
  }
}
