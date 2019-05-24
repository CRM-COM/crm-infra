
/*
FIXME: this requires recreating the cluster
resource "google_redis_instance" "main-cache" {
  memory_size_gb = 1
  name = "main-cache"
  tier = "STANDARD_HA"
  location_id = "${var.region}-a"
  alternative_location_id = "${var.region}-b"

}

output "redis_host" {
  value = "${google_redis_instance.main-cache.host}"
}

*/



//resource "helm_release" "redis" {
//  chart = "stable/redis"
//  name = "redis"
//  repository = "${data.helm_repository.stable.name}"
//  version = "6.4.4"
//  namespace = "infra"
//
//  set {
//    name = "rbac.create"
//    value = "true"
//  }
//  set {
//    name = "cluster.enabled"
//    value = "false"
//  }
//  set {
//    name = "usePassword"
//    value = "false"
//  }
//  set {
//    name = "master.persistence.enabled"
//    value = "false"
//  }
//
//  depends_on = [
//    "kubernetes_cluster_role_binding.tiller-binding"
//  ]
//}
