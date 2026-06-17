resource "helm_release" "argo_cd" {
  name       = var.name
  namespace  = var.namespace
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = var.chart_version

  # values = [
  #   file("${path.root}/../../gitops/argocd/charts/values.yaml")
  # ]

  create_namespace = true
}

resource "helm_release" "argo_apps" {
  name      = "${var.name}-apps"
  chart     = "${path.root}/../../gitops/argocd/charts"
  namespace = var.namespace
  create_namespace = false

  values = [
    file("${path.root}/../../gitops/argocd/charts/values.yaml")
  ]
  depends_on = [helm_release.argo_cd]
}

data "kubernetes_service_v1" "argo_cd" {
  metadata {
    name      = "argo-cd-argocd-server"
    namespace = var.namespace
  }

  depends_on = [helm_release.argo_cd]
}

