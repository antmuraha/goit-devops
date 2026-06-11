# Django DevOps Example Project

This is a minimal Django application for DevOps course practice and study purposes.

---

## Run with Docker/Podman

```bash
cp .env.example .env
docker-compose build
docker-compose up
```

Starts the application using Docker Compose.

Includes:

- Django application
- PostgreSQL database
- Nginx reverse proxy

After startup, the application will be available at:
[http://localhost:8080](http://localhost:8080)

---

## Local Development

For running the project without Docker, see:
[app/README.md](app/README.md)

This includes setup instructions for a local Python environment.

---

## Dev Tools

For required development tools (Docker, Docker Compose, etc.), see:
[DEVTOOLS.README.md](DEVTOOLS.README.md)

## Terraform Infrastructure

This project uses Terraform to provision and manage cloud infrastructure in AWS.  
The configuration is organized into reusable modules for better scalability and maintainability.

You can find the full Terraform configuration here [Terraform Configuration](./infra/terraform)
