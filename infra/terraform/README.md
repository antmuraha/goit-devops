# CI/CD Pipeline for Django Application using Jenkins, Terraform, Helm, and Argo CD

A complete CI/CD pipeline has been implemented using Jenkins, Terraform, Helm, and Argo CD to automate the deployment of a Django application on Kubernetes.

## 1. Project Structure

```text
├── app                                     # Django application source code
├── ci                                      # Jenkins pipeline configuration
│   └── Jenkinsfile
├── gitops                                  # Argo CD configuration
│   ├── argocd
│   │   └── charts
│   │       ├── Chart.yaml
│   │       ├── templates
│   │       │   ├── application.yaml
│   │       │   └── repository.yaml
│   │       └── values.yaml
│   └── django-app
│       ├── Chart.yaml
│       ├── templates
│       │   ├── configmap.yaml
│       │   ├── deployment.yaml
│       │   ├── hpa.yaml
│       │   ├── postgres-deployment.yaml
│       │   ├── postgres-service.yaml
│       │   └── service.yaml
│       └── values.yaml
├── infra                                    # Infrastructure as Code (IaC) configuration
│   ├── docker
│   │   └── django
│   │       └── Dockerfile
│   ├── nginx
│   │   └── default.conf
│   └── terraform
│       ├── backend.tf
│       ├── HELM_USAGE.md
│       ├── JENKINS_USAGE.md
│       ├── main.tf
│       ├── modules
│       │   ├── argo_cd
│       │   ├── ecr
│       │   ├── eks
│       │   ├── jenkins
│       │   ├── s3-backend
│       │   └── vpc
│       ├── outputs.tf
│       ├── README.md                       # This file
│       └── variables.tf
└── README.md
```

## 2. Configure environment for services

Setup environment variables:

```bash
export TF_VAR_jenkins_admin_password="SuperJenkinsPassword123"
export TF_VAR_postgres_password="SuperPostgresPassword123"

```

## 3. Initialize and apply Terraform configuration:

```bash
terraform init
terraform validate
tflint
# Comment out the provider block KUBERNETES_AND_HELM_PROVIDERS in main.tf before the first apply, then run:
terraform plan
terraform apply
```

## 4. After Terraform has created the cluster, retrieve the kubeconfig:

```bash
aws eks update-kubeconfig \
  --region us-east-1 \
  --name lesson-8-9-eks \
  --kubeconfig ./kubeconfig
```

## 5. Export kubeconfig environment variable

```bash
export KUBECONFIG=./kubeconfig
```

Then uncomment the provider blocks KUBERNETES_AND_HELM_PROVIDERS in `main.tf` and run:

```bash
terraform apply
terraform output
```

## 6. Jenkins UI

1. Log in with credentials: `admin/<password>`
2. Approve scripts in **In-process Script Approval**
3. Add GitHub PAT:
    - Manage Jenkins → Credentials → Secret Text (`github-token`)

---

## 7. Argo CD UI

1. Retrieve the initial admin password:

```bash
kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath="{.data.password}" | base64 -d && echo
```

2. Login to Argo CD UI with username `admin` and the retrieved password.

---

## 8. Verify Deployment and Services

```bash
kubectl get svc -A
kubectl get pods -A
```

The LoadBalancer endpoint provides access to Jenkins, Argo CD, and the Django application.

---

## 9. Verify HPA

```bash
kubectl get hpa -A
```

Configuration:

- Min replicas: 2
- Max replicas: 6
- Target CPU utilization: 70%

---

## 10. Destroy the Deployment Step-by-Step

Delete namespaces:

```bash
kubectl delete namespace argocd
kubectl delete namespace jenkins
kubectl delete namespace djangoapp
```

Delete remaining workloads (if needed):

```bash
kubectl delete deployment postgres
kubectl delete hpa django-hpa -n default
kubectl delete deployment django -n default
kubectl delete replicaset --all -n default
kubectl delete pod --all -n default
```

Check cleanup:

```bash
kubectl get all
kubectl get svc -A
```

Finally destroy infrastructure:

```bash
terraform destroy
```

---

## 11. Troubleshooting

If Terraform resources already exist, import them into state:

```bash
terraform import module.s3_backend.aws_s3_bucket.terraform_state goit-terraform-state-bucket
terraform import module.ecr.aws_ecr_repository.this lesson-8-9-ecr
```
