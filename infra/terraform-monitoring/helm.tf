resource "kubernetes_namespace_v1" "monitoring" {
  metadata {
    name = var.monitoring_namespace
  }
}

resource "helm_release" "kube_prometheus_stack" {
  name       = "kube-prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"

  namespace        = kubernetes_namespace_v1.monitoring.metadata[0].name
  create_namespace = false

  version = "85.2.2"

  timeout = 900
  wait    = true

  atomic          = false
  cleanup_on_fail = true

  values = [
    file("${path.module}/values/kube-prometheus-stack.yaml")
  ]

  depends_on = [
    kubernetes_secret_v1.grafana_admin
  ]
}
