#!/usr/bin/env bash

set -euo pipefail

sudo apt update

sudo apt install -y \
    docker.io \
    docker-compose-v2 \
    python3 \
    python3-pip \
    python3-venv

python3 -m venv "$HOME/django-env"

"$HOME/django-env/bin/pip" install --upgrade pip
"$HOME/django-env/bin/pip" install django

echo
docker --version
docker compose version
python3 --version
"$HOME/django-env/bin/python" -m django --version

echo
echo "Activate Django environment:"
echo "source $HOME/django-env/bin/activate"