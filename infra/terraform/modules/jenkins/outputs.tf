output "jenkins_release_name" {
  value = helm_release.jenkins.name
}

output "jenkins_namespace" {
  value = helm_release.jenkins.namespace
}

output "jenkins_url" {
  description = "Public Jenkins URL"

  value = try(
    "http://${data.kubernetes_service_v1.jenkins.status[0].load_balancer[0].ingress[0].hostname}",
    "LoadBalancer not ready yet"
  )
}