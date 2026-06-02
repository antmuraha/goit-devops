# DEV Tools installer (EDUCATIONAL PURPOSE ONLY)

Bash script for automated installation of **Docker**, **Docker Compose**, **Python 3.9+**, and **Django** on Ubuntu 24-26.

---

## Files

| File                          | Purpose                                  |
| ----------------------------- | ---------------------------------------- |
| `install_dev_tools.sh`        | Main installer script                    |
| `Test.DevTools.Dockerfile`    | Isolated test environment (Ubuntu 24.04) |
| `devtools.entrypoint.sh`      | Runs when the container starts           |

---

## Requirements

- Ubuntu 24.x - 26.x
- Root privileges (`sudo`)
- Internet access

---

## Usage

```bash
chmod +x install_dev_tools.sh
sudo ./install_dev_tools.sh
```

After installation, activate the Django virtual environment:

```bash
source /opt/django-env/bin/activate
```

---

## What gets installed

| Tool                   | Source                                                                | Notes                                        |
| ---------------------- | --------------------------------------------------------------------- | -------------------------------------------- |
| Docker Engine          | [download.docker.com](https://docs.docker.com/engine/install/ubuntu/) | Official APT repo + GPG key                  |
| Docker Compose         | docker-compose-plugin                                                 | Installed as a Docker CLI plugin             |
| Python 3.9+            | deadsnakes PPA                                                        | Skipped if a suitable version already exists |
| Django (latest stable) | pip                                                                   | Isolated in `/opt/django-env` venv           |

The script **skips any tool that is already installed** — safe to re-run.

---

## Testing with Docker

Build and run the installer inside an isolated container to avoid touching the host system:

```bash
# Build image (runs the installer during build)
docker build -t dev-tools-test . -f Test.DevTools.Dockerfile

# Start an interactive shell and inspect results
docker run --rm --privileged -it dev-tools-test
```

```text
==================================================================================
  dev-tools-test container is ready      
==================================================================================
  Docker : Docker version 29.5.2, build 79eb04c
  Docker Compose : Docker Compose version v5.1.4
  pip : pip 26.1.2 from /opt/django-env/lib/python3.12/site-packages/pip (python 3.12)
  Python : 3.12.3
  Django : 6.0.5


  Activate the venv:  source /opt/django-env/bin/activate
```

> `--privileged` is required for the test container only (Docker-in-Docker).  
> It is **not** needed when running the script directly on a host machine.

---

## Key design decisions

- **`set -euo pipefail`** — the script exits immediately on any error, unset variable, or failed pipe.
- **PEP 668 compliance** — Django is installed into `/opt/django-env` (venv) instead of the system interpreter, which Ubuntu 24+ marks as _externally managed_.
- **`systemctl` stub in Test.DevTools.Dockerfile** — replaces the real systemctl with a no-op shim so service management calls do not block the container build.
