resource "helm_release" "external_secrets" {
  name       = "external-secrets-sa"
  namespace  = "external-secrets"
  repository = "https://charts.external-secrets.io"
  chart      = "external-secrets"

  create_namespace = true

  wait    = true
  timeout = 600

  set = [
    {
      name  = "serviceAccount.name"
      value = "external-secrets-sa"
    },
    {
      name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
      value = aws_iam_role.external_secrets.arn
    }
  ]

  depends_on = [aws_iam_role_policy_attachment.external_secrets]
}