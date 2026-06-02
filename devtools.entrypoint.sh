#!/usr/bin/env bash
# devtools.entrypoint.sh — runs when the container starts
# Prints an installation summary, then drops into an interactive shell.

VENV_DIR="/opt/django-env"
DOCKER_VER=$(docker --version 2>/dev/null)
DOCKER_COMPOSE_VER=$(docker compose version 2>/dev/null)
PIP_VER=$("${VENV_DIR}/bin/python" -m pip --version 2>/dev/null)
PYTHON_VER=$(python3 --version 2>&1 | awk '{print $2}')
DJANGO_VER=$("${VENV_DIR}/bin/python" -m django --version 2>/dev/null)

# Print a summary of installed tools: Docker, Docker-compose, pip, Python and Django versions
echo ""
echo "=================================================================================="
echo "  dev-tools-test container is ready      "
echo "=================================================================================="
echo "  Docker : ${DOCKER_VER:-n/a}"     
echo "  Docker Compose : ${DOCKER_COMPOSE_VER:-n/a}"
echo "  pip : ${PIP_VER:-n/a}"
echo "  Python : ${PYTHON_VER:-n/a}"
echo "  Django : ${DJANGO_VER:-n/a}"
echo ""
echo ""
echo "  Activate the venv:  source ${VENV_DIR}/bin/activate"
echo ""

exec bash