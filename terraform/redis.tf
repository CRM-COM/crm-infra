resource "helm_release" "redis" {
  chart = "stable/redis"
  name = "redis"
  repository = "${data.helm_repository.stable.name}"
  version = "6.4.4"
  namespace = "infra"

  set {
    name = "rbac.create"
    value = "true"
  }
  set {
    name = "cluster.enabled"
    value = "false"
  }
  set {
    name = "usePassword"
    value = "false"
  }
  set {
    name = "master.persistence.enabled"
    value = "true"
  }

  depends_on = [
    "kubernetes_cluster_role_binding.tiller-binding"
  ]
}
