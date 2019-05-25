terraform {
  required_version = "~> 0.11.8"
  backend          "gcs"            {
        prefix  = "terraform/main"
  }
}

provider "template" {
  version = "~> 1.0"
}

provider "tls" {
  version = "~> 1.1"
}

provider "random" {
  version = "~> 2.0"
}

provider "google" {
  credentials = "../keys/terraform-${var.environment}.json"
  project     = "${var.project}"
  region      = "${var.region}"
  zone        = "${var.zone}"
  version     = "~> 2.0.0"
}

provider "mysql" {
  version = "~> 1.5"
  endpoint = "${google_sql_database_instance.main_sql.first_ip_address}:3306"
  username = "mysqladmin"
  password = "${random_string.mysql_admin_password.result}"
}

provider "kubernetes" {
  version =  "~> 1.5"
  host                   = "https://${google_container_cluster.main.endpoint}"
  username               = "k8admin"
  password               = "${random_string.k8s-master-password.result}"
  cluster_ca_certificate = "${base64decode(google_container_cluster.main.master_auth.0.cluster_ca_certificate)}"
}

provider "helm" {
  version = "~> 0.9"
  install_tiller = true
  service_account = "${kubernetes_service_account.tiller-sa.metadata.0.name}"
  max_history = 5
  home = "/tmp/helm-tf"

  kubernetes {
    host                   = "https://${google_container_cluster.main.endpoint}"
    username               = "k8admin"
    password               = "${random_string.k8s-master-password.result}"
    cluster_ca_certificate = "${base64decode(google_container_cluster.main.master_auth.0.cluster_ca_certificate)}"
  }
}