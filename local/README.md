# Local Development & Testing

This folder contains resources and instructions for running and testing the microservices app locally using either Docker Compose or Kind (Kubernetes in Docker).

## Structure
- `compose/` — Docker Compose files and environment for local multi-container testing.
- `kind/` — Scripts and documentation for running the stack on a local Kind cluster with Helm.

## Usage
- Use `compose/` for quick local development and integration testing with Docker Compose.
- Use `kind/` for testing Kubernetes manifests and Helm charts in a local cluster before deploying to real Kubernetes environments.
