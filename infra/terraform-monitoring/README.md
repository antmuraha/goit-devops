# Kubernetes Monitoring Stack (kube-prometheus-stack)

This directory defines a standalone **observability layer** for an existing AWS EKS cluster using Terraform and the `kube-prometheus-stack` Helm chart.

The stack provides a full Kubernetes-native monitoring solution based on the **Prometheus Operator pattern**, including Prometheus, Grafana, Alertmanager, and core exporters.

---

## Architecture Overview

The monitoring system is based on the Prometheus Operator model:

- Prometheus Operator manages monitoring resources via Kubernetes CRDs
- Prometheus collects metrics using ServiceMonitor / PodMonitor objects
- Grafana visualizes metrics with pre-provisioned dashboards
- Alertmanager handles alert routing and notifications

Data flow:

```

Kubernetes workloads → Exporters → Prometheus → Alertmanager → Grafana

```

---

## Stack Components

The deployed Helm chart (`kube-prometheus-stack`) includes:

- Prometheus Operator (CRD controller)
- Prometheus server
- Alertmanager
- Grafana
- kube-state-metrics
- node-exporter (DaemonSet)

All components are deployed inside a dedicated `monitoring` namespace.

---

## Prerequisites

- Existing AWS EKS cluster provisioned via `terraform/`
- Kubernetes & Helm providers configured in Terraform
- Access to cluster credentials (via AWS IAM or kubeconfig)
- Terraform >= 1.5.0

---

## Deployment

### 1. Initialize Terraform

```bash
terraform init
```

### 2. Validate configuration

```bash
terraform validate
```

### 3. Deploy monitoring stack

```bash
terraform apply
```

---

## Configuration Structure

### Core Terraform files

- `main.tf` - provider requirements
- `providers.tf` - EKS connection (AWS → Kubernetes → Helm)
- `helm.tf` - kube-prometheus-stack Helm release
- `variables.tf` - cluster and Grafana configuration inputs

### Helm configuration

All custom configuration is defined in:

```
values/kube-prometheus-stack.yaml
```

This file controls:

- Prometheus retention and storage
- Grafana admin settings and persistence
- Node exporter & kube-state-metrics enabling
- Alertmanager configuration

---

## Grafana Access

After deployment:

```bash
kubectl port-forward -n monitoring svc/kube-prometheus-stack-grafana 3000:80
```

Access:

```
http://localhost:3000
```

Default credentials:

- Username: `admin`
- Password: defined in Terraform variable `grafana_admin_password`

---

## Prometheus Access

Prometheus is available internally within the cluster:

```
http://kube-prometheus-stack-prometheus.monitoring.svc:9090
```

Used primarily by Grafana as a data source.

---

## Metrics Collection Model

This stack uses Kubernetes-native discovery via the Prometheus Operator:

Instead of static scrape configs, monitoring targets are defined using:

- `ServiceMonitor`
- `PodMonitor`

This allows automatic discovery of services exposing metrics via Kubernetes labels.

---

## Dashboards

Grafana dashboards are provisioned via Kubernetes ConfigMaps:

```
dashboards/node-exporter.json
```

Dashboards are automatically loaded via Grafana sidecar mechanism.

---

## Integration with Application Infrastructure

This monitoring stack is **decoupled from core infrastructure Terraform state**.

It depends only on:

- EKS cluster name
- Kubernetes API access credentials

It does NOT manage:

- VPC
- EKS lifecycle
- application workloads

This ensures:

- independent lifecycle management
- reduced blast radius
- safe upgrades of observability layer

---

## Extending Monitoring

To expose metrics from applications:

1. Add `ServiceMonitor` or `PodMonitor`
2. Ensure application exposes `/metrics` endpoint
3. Apply CRD manifests in the cluster

Example:

```
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: my-service
spec:
  selector:
    matchLabels:
      app: my-service
  endpoints:
    - port: http
      path: /metrics
```

---

## Upgrade Strategy

The stack is upgraded by changing:

- Helm chart version in `helm.tf`
- Values in `kube-prometheus-stack.yaml`

Apply changes via Terraform:

```bash
terraform apply
```

---

## Design Rationale

This setup uses the **Prometheus Operator pattern** because it provides:

- Native Kubernetes integration
- Automated service discovery
- Declarative monitoring configuration
- Scalable multi-service observability

Compared to standalone Prometheus setups, it reduces manual scrape configuration and improves maintainability in dynamic environments.

---

## Notes

- Grafana dashboards and datasources are managed automatically via sidecar provisioning
- Prometheus does not require manual scrape configuration
- Alert rules are managed via PrometheusRule CRDs (not YAML scrape configs)

---

## Troubleshooting

Reset Grafana admin password:

```bash
kubectl exec -n monitoring deploy/kube-prometheus-stack-grafana \
  -- grafana cli admin reset-admin-password MyNewStrongPassword123
```
