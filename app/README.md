# Microservices Sample App

This is a production-ready, Container based microservices sample application. It demonstrates best practices for building, running, and orchestrating a modern web app with a React frontend, Node.js/Express backend, and PostgreSQL database.

## Architecture
- **Frontend:** React SPA served by Nginx, with dynamic backend proxy configuration.
- **Backend:** Node.js/Express API, connects to Postgres, auto-creates required tables.
- **Database:** PostgreSQL, with persistent storage.

## Key Best Practices Implemented

- **Dynamic Configuration:**
  - All service URLs and ports are configurable via environment variables (e.g., `BACKEND_URL`, `POSTGRES_CONNECTION_STRING`).
  - No hardcoded service addresses or ports.

- **Minimal, Secure Images:**
  - Multi-stage Docker builds for both frontend and backend.
  - Only production dependencies and build output are included in final images.
  - Nginx and Node.js containers run as non-root users (rootless), with correct file permissions.
  - No unnecessary files or build artifacts left in the final images.

- **Health Checks & Dependency Management:**
  - Backend and database expose health endpoints for robust startup and orchestration.
  - Docker Compose uses `depends_on` with `condition: service_healthy` to ensure correct startup order.

- **Dynamic Nginx Proxy:**
  - Nginx config is templated at container startup using environment variables, allowing the backend URL to be changed without rebuilding the image.
  - No hardcoded backend host/port in the frontend image.

- **Database Initialization:**
  - Backend auto-creates the required `messages` table if it does not exist—no need for manual SQL scripts or init files.

- **Clean Source Control:**
  - `.env` and other sensitive or unnecessary files are excluded via `.gitignore`.

## Usage

1. Copy `.env` and fill in your secrets.
2. Run `docker-compose up --build` from the `app` directory.
3. Access the frontend at [http://localhost:8080](http://localhost:8080).

## Folder Structure
- `frontend/` — React app, Nginx config, Dockerfile, entrypoint script
- `backend/` — Node.js API, Dockerfile
- `docker-compose.yml` — Orchestration for all services

## Extending
- Easily add new services or swap out components thanks to dynamic configuration and health checks.
- Ready for migration to Kubernetes (see `helm/` for Helm chart scaffolding).