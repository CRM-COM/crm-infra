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

  set {
    name = "environment"
    value = "${var.environment}"
  }
  set {
    name = "domain"
    value = "${var.domain}"
  }
}

//resource "helm_release" "sealed-secrets" {
//  chart = "stable/sealed-secrets"
//  name = "sealed-secrets-controller"
//  repository = "${data.helm_repository.stable.name}"
//  version = "1.0.1"
//  namespace = "kube-system"
//
//  depends_on = [
//    "kubernetes_cluster_role_binding.tiller-binding"
//  ]
}