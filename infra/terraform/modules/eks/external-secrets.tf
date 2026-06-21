resource "helm_release" "external_secrets" {
  name       = "external-secrets-sa"
  namespace  = "external-secrets"
  repository = "https://charts.external-secrets.io"
  chart      = "external-secrets"

  create_namespace = true

  wait    = true
  timeout = 600
}