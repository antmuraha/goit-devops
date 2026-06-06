# DEV Tools installer (EDUCATIONAL PURPOSE ONLY)

Bash script for automated installation of **Docker**, **Docker Compose**, **Python 3.9+**, and **Django** on Debian/Ubuntu.

---

## Files

| File                       | Purpose                                  |
| -------------------------- | ---------------------------------------- |
| `install_dev_tools.sh`     | Main installer script                    |
| `Test.DevTools.Dockerfile` | Isolated test environment (Ubuntu 24.04) |
| `devtools.entrypoint.sh`   | Runs when the container starts           |

---

## Requirements

- Debian/Ubuntu
- Root privileges (`sudo`)
- Internet access

---

## Usage

### Save and Run

```bash
nano install-dev-tools.sh
chmod +x install-dev-tools.sh
./install-dev-tools.sh
```

### Activate the Django Environment

```bash
source ~/django-env/bin/activate
```

### Installation Location

The Python virtual environment is created in:

```text
~/django-env
```

After activation, all Python packages installed with `pip` will be isolated to this environment and will not affect the system Python installation.

### Installed Components

- Docker Engine
- Docker Compose (v2)
- Python 3
- pip
- Python virtual environment support (`venv`)
- Django (installed inside `~/django-env`)

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
docker run --rm -it dev-tools-test
```

```text
==================================================================================
  dev-tools-test container is ready
==================================================================================
  Docker : Docker version 29.1.3, build 29.1.3-0ubuntu3~24.04.2
  Docker Compose : Docker Compose version 2.40.3+ds1-0ubuntu1~24.04.1
  pip : pip 26.1.2 from /root/django-env/lib/python3.12/site-packages/pip (python 3.12)
  Python : 3.12.3
  Django : 6.0.6


  Activate the venv:  source /root/django-env/bin/activate
```