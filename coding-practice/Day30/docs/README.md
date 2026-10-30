cat > coding-practice/Day30/README.md <<'EOF'
# Day 30 - Final Pathnex DevOps Project

## Project Overview

Final submission for the Pathnex 30-Day DevOps Challenge.

## Technologies

- AWS
- Terraform
- Ansible
- Docker
- Kubernetes
- Helm
- Jenkins
- GitLab CI/CD
- Prometheus

## Architecture

Developer
   |
   v
GitHub Repository
   |
   v
Jenkins / GitLab CI/CD
   |
   v
Helm Deployment
   |
   v
Kubernetes Cluster
   |
   v
Pathnex Nginx Application

Terraform separately provisions AWS networking and EC2.

## Infrastructure

Terraform includes:
- VPC
- Public subnet
- Internet Gateway
- Route table
- Security group
- EC2 instance

## Terraform Validation

cd terraform
terraform init
terraform fmt -check
terraform validate

For an authorized deployment, supply a valid AMI ID:

terraform plan -var="ami_id=<VALID_AMI_ID>"

Review the plan before any apply operation.

## Kubernetes Deployment

kubectl apply -f kubernetes/deployment.yaml

kubectl get pods
kubectl get svc

## Helm Deployment

helm lint helm/pathnex

helm upgrade --install pathnex helm/pathnex \
  --namespace pathnex \
  --create-namespace

kubectl get pods -n pathnex

## CI/CD

Jenkins and GitLab pipeline examples are provided.
Configure credentials, runner tools and Kubernetes access
before enabling deployment jobs.

## Security

- AWS security group
- Kubernetes NetworkPolicy
- Container resource limits
- Non-root Docker image example

## Monitoring

Prometheus scrape configuration is included.
Application metrics instrumentation is still required.

## Limitations

This repository is a learning starter project.
It is not a verified end-to-end production deployment.

RDS, application backend, database integration,
live monitoring dashboards and production hardening
are not implemented.

## Final Review Checklist

- Terraform validation
- Kubernetes manifest validation
- Helm lint
- Jenkins pipeline review
- GitLab pipeline review
- Security configuration review
- Documentation review
EOF