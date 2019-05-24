

resource "kubernetes_service_account" "tiller-sa" {
  "metadata" {
    name = "tiller-sa"
    namespace = "kube-system"
  }
}

resource "kubernetes_cluster_role_binding" "tiller-binding" {
  "metadata" {
    name = "tiller-binding"
  }
  "role_ref" {
    name = "cluster-admin"
    kind = "ClusterRole"
    api_group = "rbac.authorization.k8s.io"
  }

  "subject" {
    kind = "ServiceAccount"
    name = "${kubernetes_service_account.tiller-sa.metadata.0.name}"
    namespace = "kube-system"
    api_group = ""
  }
}