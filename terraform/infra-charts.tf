data "helm_repository" "stable" {
  name = "stable"
  url  = "https://kubernetes-charts.storage.googleapis.com"
}
data "helm_repository" "incubator" {
  name = "incubator"
  url  = "https://kubernetes-charts-incubator.storage.googleapis.com/"
}

resource "helm_release" "certificates-backend" {
  name = "certificates-backend"
  chart = "../helm/tls-certs-backend"
  namespace = "backend"
  version = "0.1.1"

  set {
    name = "environment"
    value = "${var.environment}"
  }
  set {
    name = "domain"
    value = "${var.domain}"
  }
}

resource "helm_release" "certificates-swagger" {
  name = "certificates-swagger"
  chart = "../helm/tls-certs-swagger"
  namespace = "backend"
  version = "0.1.0"

  set {
    name = "environment"
    value = "${var.environment}"
  }
  set {
    name = "domain"
    value = "${var.domain}"
  }
}

resource "helm_release" "certificates-keycloak" {
  name = "certificates-keycloak"
  chart = "../helm/tls-certs-keycloak"
  namespace = "infra"
  version = "0.1.0"

  set {
    name = "environment"
    value = "${var.environment}"
  }
  set {
    name = "domain"
    value = "${var.domain}"
  }
}

resource "helm_release" "certificates-dashboard" {
  name = "certificates-dashboard"
  chart = "../helm/tls-certs-dashboard"
  namespace = "web"
  version = "0.1.0"

  set {
    name = "environment"
    value = "${var.environment}"
  }
  set {
    name = "domain"
    value = "${var.domain}"
  }
}

resource "helm_release" "infra" {
  name = "infra"
  chart = "../helm/infra"
  namespace = "infra"
  version = "0.1.2"

  set {
    name = "environment"
    value = "${var.environment}"
  }
  set {
    name = "domain"
    value = "${var.domain}"
  }
}

resource "helm_release" "sealed-secrets" {
  chart = "stable/sealed-secrets"
  name = "sealed-secrets-controller"
  repository = "${data.helm_repository.stable.name}"
  version = "1.0.1"
  namespace = "kube-system"

  depends_on = [
    "kubernetes_cluster_role_binding.tiller-binding"
  ]
}