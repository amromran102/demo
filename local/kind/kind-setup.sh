#!/bin/bash
# Kind + Helm Microservices Setup Script (Step 1-7)
# Usage: ./kind-setup.sh
set -euo pipefail

# Prompt for cluster name (default: demo)
read -p "Enter Kind cluster name [demo]: " CLUSTER_NAME
CLUSTER_NAME=${CLUSTER_NAME:-demo}
APP_DIR="$(dirname "$0")/../../app"

# 1. Create Kind cluster (skip if exists)
if kind get clusters | grep -q "^$CLUSTER_NAME$"; then
  echo "Kind cluster '$CLUSTER_NAME' already exists. Skipping creation."
else
  kind create cluster --name "$CLUSTER_NAME"
fi

# 2. Set kubectl context
kubectl cluster-info --context kind-$CLUSTER_NAME || true
kubectl config use-context kind-$CLUSTER_NAME

# 3. Build Docker images (from app directory, but run from script dir)
echo "Building frontend image..."
docker build -t app-frontend:latest "$APP_DIR/frontend"
echo "Building backend image..."
docker build -t app-backend:latest "$APP_DIR/backend"

# 4. Load images into Kind
kind load docker-image app-frontend:latest --name "$CLUSTER_NAME"
kind load docker-image app-backend:latest --name "$CLUSTER_NAME"

# 5. Create namespace for the app
NAMESPACE="sample-app"
kubectl get namespace "$NAMESPACE" >/dev/null 2>&1 || kubectl create namespace "$NAMESPACE"

# 6. Deploy PostgreSQL with Helm using custom values
helm upgrade --install postgres-db ../../helm/postgres-standalone/postgresql \
  --namespace "$NAMESPACE" \
  -f ./postgres-values.yaml

# Wait for PostgreSQL to be ready
echo "Waiting for PostgreSQL pod to be ready..."
kubectl rollout status statefulset/postgres-db-postgresql -n "$NAMESPACE" --timeout=120s

# 7. Deploy the App with Helm using custom values
helm upgrade --install microservices-app ../../helm/app \
  --namespace "$NAMESPACE" \
  -f ./app-values.yaml

echo
echo "Deployment complete. Check resources with: kubectl get all -n $NAMESPACE"
echo "Kind cluster '$CLUSTER_NAME' is ready and images are loaded."