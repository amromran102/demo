# Local Development & Testing

This folder contains resources and instructions for running and testing the microservices app locally using either Docker Compose or Kind (Kubernetes in Docker).

## Structure
- `compose/` — Docker Compose files and environment for local multi-container testing.
- `kind/` — Scripts and documentation for running the stack on a local Kind cluster with Helm.

## Usage
- Use `compose/` for quick local development and integration testing with Docker Compose.
- Use `kind/` for testing Kubernetes manifests and Helm charts in a local cluster before deploying to real Kubernetes environments.

## Running the Kind Setup Script

To deploy the full stack on a local Kind cluster:

1. Ensure you have [Kind](https://kind.sigs.k8s.io/) and [Helm](https://helm.sh/) installed.
2. Create the following files in `local/kind/`:

- `postgres-values.yaml`:
  ```yaml
  auth:
    postgresPassword: myadminpassword
    username: myuser
    password: securepassword123
    database: ideasdb
  ```
- `app-values.yaml`:
  ```yaml
  frontend:
    image: app-frontend:latest
    env:
      BACKEND_URL: http://backend:3000

  backend:
    image: app-backend:latest
    env:
      PORT: "3000"

  secrets:
    DBconnectionString: "postgresql://myuser:securepassword123@postgres-db-postgresql.sample-app.svc.cluster.local:5432/ideasdb"
  ```

3. Run the setup script:

```sh
cd local/kind
chmod +x kind-setup.sh
./kind-setup.sh
```

This will:
- Create a Kind cluster (if not already present)
- Build and load Docker images
- Deploy PostgreSQL and the app using your custom values
- Wait for the database to be ready before deploying the app

Check resources with:
```sh
kubectl get all -n sample-app
```

> **Note:** Do not commit your `app-values.yaml` or `postgres-values.yaml` files to version control, as they may contain secrets.
