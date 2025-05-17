# Local Development & Testing

This folder contains resources and instructions for running and testing the microservices app locally using either Docker Compose or Kind (Kubernetes in Docker).

## Structure
- `compose/` — Docker Compose files, `.env` example, and persistent volume for local multi-container testing.
  - `docker-compose.yml` — Compose file for frontend, backend, and Postgres.
  - `.env` — Environment variables for Compose (user must create).
- `kind/` — Scripts, custom values files, and documentation for running the stack on a local Kind cluster with Helm.
  - `kind-setup.sh` — Automated setup script for Kind + Helm workflow.
  - `app-values.yaml` — Example override values for the app Helm chart (user must create).
  - `postgres-values.yaml` — Example override values for the Postgres Helm chart (user must create).
- `README.md` — This documentation file.

## Usage
- Use `compose/` for quick local development and integration testing with Docker Compose.
- Use `kind/` for testing Kubernetes manifests and Helm charts in a local cluster before deploying to real Kubernetes environments.

## Running with Docker Compose

To run the stack locally using Docker Compose:

1. Copy or create a `.env` file in `local/compose/` with the following content (example):

   ```env
   POSTGRES_USER=myuser
   POSTGRES_PASSWORD=securepassword123
   POSTGRES_DB=ideasdb
   POSTGRES_CONNECTION_STRING=postgresql://myuser:securepassword123@postgres:5432/ideasdb
   ```

2. Start the stack:

   ```sh
   cd local/compose
   docker compose up --build
   ```

This will build the images and start all services (frontend, backend, postgres) with the correct environment variables for local development.

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
