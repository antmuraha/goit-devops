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
- `backend.tf` - Terraform state backend configuration
- `secrets.tf` - sensitive values (Grafana password, etc.)

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

Prometheus can be accessed via port-forwarding:

```bash
kubectl port-forward -n monitoring svc/kube-prometheus-stack-prometheus 9090:9090
```

Prometheus UI is available at:

```
http://localhost:9090
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
