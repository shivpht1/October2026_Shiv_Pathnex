
#!/bin/bash
set -e

# Add the NGINX Ingress Helm repository
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx

# Update Helm repositories
helm repo update

# Install NGINX Ingress Controller
helm upgrade --install pathnex-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx \
  --create-namespace

# Verify Helm release
helm list -n ingress-nginx

# Check Kubernetes resources
kubectl get pods -n ingress-nginx
kubectl get services -n ingress-nginx
