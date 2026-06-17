# Jenkins Usage Guide
To simplify testing, we will run the Jenkins service on AWS with minimal dependencies.

Cluster must be existing OR run target `eks` first to create the EKS cluster.
```bash
terraform apply -target=module.eks
```