output "argo_cd_server_service" {
  description = "Argo CD server service"
  value       = "argo-cd.${var.namespace}.svc.cluster.local"
}

output "admin_password" {
  description = "Initial admin password"
  value       = "Run: kubectl -n ${var.namespace} get secret argocd-initial-admin-secret -o jsonpath={.data.password} | base64 -d"
}

output "argocd_url" {
  value = try(
    "http://${data.kubernetes_service_v1.argo_cd.status[0].load_balancer[0].ingress[0].hostname}",
    "Argo CD LoadBalancer not ready yet"
  )
}