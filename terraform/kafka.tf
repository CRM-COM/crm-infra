resource "helm_release" "kafka" {
  chart = "incubator/kafka"
  name = "kafka-broker"
  version = "0.15.3"
  namespace = "infra"
  repository = "${data.helm_repository.incubator.name}"

  set {
    name = "persistence.size"
    value = "3Gi"
  }
  set {
    name = "imageTag"
    value = "5.2.1"   # kafka 2.2
  }
}