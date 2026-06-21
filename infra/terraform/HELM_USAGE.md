# Django App Helm Deployment

This document describes how to deploy the Django application (without DB) to Kubernetes using **Helm**, assuming the following prerequisites have been completed:

- A Kubernetes cluster has been created via Terraform and is running (see [README.md](README.md) for details).
- An ECR repository exists.
- Terraform outputs provide the necessary information (`ECR repository URL`, `kubeconfig`).

---

## 1. Configure `kubectl` for the cluster

After Terraform has created the cluster, retrieve the kubeconfig:

```bash
# Save kubeconfig output from Terraform
terraform output -raw kubeconfig > ./kubeconfig

# Update kubeconfig for AWS EKS
aws eks update-kubeconfig \
  --region us-east-1 \
  --name lesson-11-eks \
  --kubeconfig ./kubeconfig

# Export kubeconfig environment variable
export KUBECONFIG=./kubeconfig

# Verify access to the cluster
kubectl get nodes
```

You should see the cluster nodes listed, confirming that `kubectl` can access the cluster.

---

## 2. Push Docker image to ECR

Authenticate Docker (or Podman) with ECR:

```bash
aws ecr get-login-password --region us-east-1 | \
docker login --username AWS --password-stdin <ECR_REPOSITORY_URL>
```

Retrieve the ECR repository URL from Terraform:

```bash
terraform output ecr_repository_url
# Example output:
# 123456789012.dkr.ecr.us-east-1.amazonaws.com/lesson-11-ecr
```

Build and tag the Docker image:

```bash
# From the root of the project
# Build the image using Podman or Docker
podman build -t lesson-11-django ./app -f infra/docker/django/Dockerfile

# Tag the image with the ECR repository URL
docker tag lesson-11-django:latest <ECR_REPOSITORY_URL>:latest
```

Push the image to ECR:

```bash
docker push <ECR_REPOSITORY_URL>:latest
```

> Replace `<ECR_REPOSITORY_URL>` with the actual value from Terraform output.

---

## 3. Deploy Django App using Helm

To render Kubernetes manifests without deploying, use:

```bash
helm template ./charts/django-app \
    --set image.repository=<ECR_REPOSITORY_URL> \
    --set image.tag=latest \
    --set service.type=LoadBalancer \
    --set service.port=80 \
    --set hpa.minReplicas=2 \
    --set hpa.maxReplicas=6 \
    --set hpa.targetCPUUtilizationPercentage=70 \
    --set env.POSTGRES_HOST=db \
    --set env.POSTGRES_PORT=5432 \
    --set env.POSTGRES_DB=postgres \
    --set env.POSTGRES_USER=postgres \
    --set env.POSTGRES_PASSWORD='SuperSecretPassword'
```

Check existing Helm releases:

```bash
helm list
```

Install the Helm chart and pass all values via `--set` (without using `values.yaml`):

```bash
helm install django-app ./charts/django-app \
  --set image.repository=<ECR_REPOSITORY_URL> \
  --set image.tag=latest \
  --set service.type=LoadBalancer \
  --set service.port=80 \
  --set hpa.minReplicas=2 \
  --set hpa.maxReplicas=6 \
  --set hpa.targetCPUUtilizationPercentage=70 \
  --set env.POSTGRES_HOST=db \
  --set env.POSTGRES_PORT=5432 \
  --set env.POSTGRES_DB=postgres \
  --set env.POSTGRES_USER=postgres \
  --set env.POSTGRES_PASSWORD='SuperSecretPassword'
```

> Note: Use `helm upgrade` if the release already exists.

---

## 4. Verify Deployment and Service

Check the deployment:

```bash
kubectl get deployment
```

Check the service:

```bash
kubectl get svc
```

Check the pods:

```bash
kubectl get pods
```

Check the external LoadBalancer IP:

```bash
kubectl get svc django-service
```

The LoadBalancer IP or DNS allows access to the Django application from the Internet.

---

## 5. Verify HPA

```bash
kubectl get hpa
```

- Minimum replicas: 2
- Maximum replicas: 6
- Target CPU utilization: 70%

Ensure the HPA scales pods according to CPU load.

---

## 6. Verify ConfigMap and Secrets

Check the ConfigMap:

```bash
kubectl get configmap django-config -o yaml
```

Check the Secret:

```bash
kubectl get secret django-secret -o yaml
```

## 7. Destroy the Deployment Step-by-Step

Uninstall the Helm release:

```bash
helm uninstall django-app
```

Check that all resources are removed:

```bash
kubectl get all
kubectl get svc -A
```

Only after confirming that all resources are deleted, you can proceed to destroy the cluster with Terraform.

```bash
terraform destroy
```
