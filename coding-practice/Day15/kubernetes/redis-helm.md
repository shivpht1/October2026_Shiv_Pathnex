
# Day15 — Deploy Redis Using Helm with Persistence

## 1. Add the Bitnami Helm Repository

helm repo add bitnami https://charts.bitnami.com/bitnami

## 2. Update Helm Repositories

helm repo update

## 3. Create a Kubernetes Namespace

kubectl create namespace day15-practice

## 4. Install Redis with Persistent Storage

helm install pathnex-redis bitnami/redis \
  --namespace day15-practice \
  --set persistence.enabled=true \
  --set persistence.size=8Gi

## 5. Verify Redis Pods

kubectl get pods -n day15-practice

## 6. Check Persistent Volume Claims

kubectl get pvc -n day15-practice

## 7. Check Helm Release

helm list -n day15-practice

## 8. Check Redis Services

kubectl get svc -n day15-practice



