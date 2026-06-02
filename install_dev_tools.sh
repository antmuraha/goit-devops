#!/usr/bin/env bash
# ==============================================================================
# install_dev_tools.sh
# Automated installer for Docker, Docker Compose, Python 3.9+, and Django
# Target platform: Ubuntu 24.x - 26.x (LTS)
# ==============================================================================
# Usage:
#   chmod +x install_dev_tools.sh
#   sudo ./install_dev_tools.sh
# ==============================================================================

# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║                              DISCLAIMER                                    ║
# ╠══════════════════════════════════════════════════════════════════════════════╣
# ║                                                                            ║
# ║  EDUCATIONAL PURPOSE ONLY                                                  ║
# ║  ─────────────────────────                                                 ║
# ║  This script is provided solely as a learning example to demonstrate       ║
# ║  automated package installation, idempotency checks, and Bash best         ║
# ║  practices on Ubuntu. It is NOT intended for use on production systems,    ║
# ║  shared servers, or any environment where stability and security are        ║
# ║  critical concerns.                                                         ║
# ║                                                                            ║
# ║  USE AT YOUR OWN RISK                                                       ║
# ║  ────────────────────                                                       ║
# ║  The authors assume no responsibility for data loss, system instability,   ║
# ║  security vulnerabilities, or any other damage resulting from running       ║
# ║  this script. Always review scripts from untrusted sources before          ║
# ║  executing them with root privileges.                                       ║
# ║                                                                            ║
# ║  PACKAGES THAT SHOULD NOT BE INSTALLED GLOBALLY                            ║
# ║  ─────────────────────────────────────────────                             ║
# ║  The following tools are installed globally by this script for             ║
# ║  simplicity. In real-world projects this is considered bad practice:       ║
# ║                                                                            ║
# ║  • Django (and any third-party Python packages)                            ║
# ║    Reason: different projects require different versions. Global           ║
# ║    installation leads to dependency conflicts. Always use a per-project    ║
# ║    virtual environment (python -m venv) or an isolation tool such as       ║
# ║    pipenv, poetry, or uv.                                                  ║
# ║                                                                            ║
# ║  • pip packages in general                                                 ║
# ║    Reason: pip install --break-system-packages bypasses the protection     ║
# ║    Ubuntu 24+ introduced under PEP 668. Modifying the system interpreter   ║
# ║    can break OS-level tools that depend on specific library versions.      ║
# ║                                                                            ║
# ║  WHAT IS SAFE TO INSTALL GLOBALLY                                          ║
# ║  ─────────────────────────────────                                         ║
# ║  • Docker Engine and Docker Compose — system-level daemons and CLI        ║
# ║    tools with no per-project version requirement.                          ║
# ║  • Python runtime itself — the interpreter is a system dependency,        ║
# ║    not an application library.                                             ║
# ║                                                                            ║
# ║  RECOMMENDED APPROACH FOR REAL PROJECTS                                    ║
# ║  ──────────────────────────────────────                                    ║
# ║  1. Install only Docker + Python globally (via this script or manually).  ║
# ║  2. Create a project-scoped virtual environment:                           ║
# ║       python3 -m venv .venv && source .venv/bin/activate                  ║
# ║  3. Install all Python dependencies inside the venv:                       ║
# ║       pip install django                                                   ║
# ║  4. Pin versions and commit requirements:                                  ║
# ║       pip freeze > requirements.txt                                        ║
# ║                                                                            ║
# ╚══════════════════════════════════════════════════════════════════════════════╝

set -euo pipefail   # -e exit on error, -u treat unset vars as error, -o pipefail

# ── Colors helpers ─────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

info()    { echo -e "${CYAN}[INFO]${RESET}  $*"; }
success() { echo -e "${GREEN}[OK]${RESET}    $*"; }
warn()    { echo -e "${YELLOW}[WARN]${RESET}  $*"; }
error()   { echo -e "${RED}[ERROR]${RESET} $*" >&2; }
header()  { echo -e "\n${BOLD}${CYAN}══ $* ══${RESET}"; }

# ── Guard: must run as root ────────────────────────────────────────────────────
if [[ "${EUID}" -ne 0 ]]; then
    error "This script must be run as root (use: sudo $0)"
    exit 1
fi

# ── Helper: version comparison (major.minor) ───────────────────────────────────
# Returns 0 (true) when $1 >= $2
version_gte() {
    printf '%s\n%s' "$2" "$1" | sort -V -C
}

# ── Helper: check if a command exists ─────────────────────────────────────────
cmd_exists() { command -v "$1" &>/dev/null; }

# ── Step 0: Update package index ──────────────────────────────────────────────
header "Updating package index"
apt-get update -qq
success "Package index updated."

# ── Step 1: Install prerequisite packages ─────────────────────────────────────
header "Installing prerequisites"
PREREQS=(
    ca-certificates
    curl
    gnupg
    lsb-release
    software-properties-common
    apt-transport-https
    python3.12-venv
)
apt-get install -y -qq "${PREREQS[@]}"
success "Prerequisites installed."

# ==============================================================================
# DOCKER
# Official guide: https://docs.docker.com/engine/install/ubuntu/
# ==============================================================================
header "Docker"

if cmd_exists docker; then
    DOCKER_VER=$(docker --version 2>/dev/null | grep -oP '[\d]+\.[\d]+\.[\d]+' | head -1)
    warn "Docker is already installed (version ${DOCKER_VER}). Skipping."
else
    info "Docker not found - installing via official Docker repository…"

    # Remove any unofficial / legacy packages that may conflict
    LEGACY_PKGS=(docker.io docker-doc docker-compose docker-compose-v2
                 podman-docker containerd runc)
    for pkg in "${LEGACY_PKGS[@]}"; do
        apt-get remove -y -qq "${pkg}" 2>/dev/null || true
    done

    # Add Docker's official GPG key
    install -m 0755 -d /etc/apt/keyrings
    curl -fsSL "https://download.docker.com/linux/ubuntu/gpg" \
        | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    chmod a+r /etc/apt/keyrings/docker.gpg

    # Add the Docker APT repository
    # Uses the Ubuntu codename reported by lsb_release
    UBUNTU_CODENAME=$(lsb_release -cs)
    echo \
        "deb [arch=$(dpkg --print-architecture) \
signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/ubuntu \
${UBUNTU_CODENAME} stable" \
        > /etc/apt/sources.list.d/docker.list

    apt-get update -qq

    # Install the latest stable Docker Engine + CLI + containerd
    apt-get install -y -qq \
        docker-ce \
        docker-ce-cli \
        containerd.io \
        docker-buildx-plugin

    # Enable and start the Docker service
    systemctl enable --now docker

    DOCKER_VER=$(docker --version 2>/dev/null | grep -oP '[\d]+\.[\d]+\.[\d]+' | head -1)
    success "Docker ${DOCKER_VER} installed and service started."
fi

# ==============================================================================
# DOCKER COMPOSE (plugin)
# Official guide: https://docs.docker.com/compose/install/linux/
# ==============================================================================
header "Docker Compose"

if docker compose version &>/dev/null 2>&1; then
    DC_VER=$(docker compose version --short 2>/dev/null || \
             docker compose version 2>/dev/null | grep -oP '[\d]+\.[\d]+\.[\d]+' | head -1)
    warn "Docker Compose (plugin) is already installed (version ${DC_VER}). Skipping."
else
    info "Docker Compose plugin not found - installing…"

    # The compose plugin ships as part of docker-compose-plugin package
    apt-get install -y -qq docker-compose-plugin

    DC_VER=$(docker compose version --short 2>/dev/null || \
             docker compose version 2>/dev/null | grep -oP '[\d]+\.[\d]+\.[\d]+' | head -1)
    success "Docker Compose plugin ${DC_VER} installed."
fi

# ==============================================================================
# PYTHON 3
# Ubuntu 24+ ships Python 3.12; deadsnakes PPA covers older/newer versions.
# Official PPA: https://launchpad.net/~deadsnakes/+archive/ubuntu/ppa
# Minimum required: 3.9
# ==============================================================================
header "Python 3"

MIN_PYTHON_MAJOR=3
MIN_PYTHON_MINOR=9
REQUIRED_PYTHON="${MIN_PYTHON_MAJOR}.${MIN_PYTHON_MINOR}"

# Resolve which python3 binary is available and whether it satisfies the floor
PYTHON_BIN=""
for candidate in python3 python3.13 python3.12 python3.11 python3.10 python3.9; do
    if cmd_exists "${candidate}"; then
        PY_VER=$("${candidate}" -c \
            "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')" \
            2>/dev/null) || continue
        if version_gte "${PY_VER}" "${REQUIRED_PYTHON}"; then
            PYTHON_BIN="${candidate}"
            break
        fi
    fi
done

if [[ -n "${PYTHON_BIN}" ]]; then
    warn "Python ${PY_VER} already satisfies >= ${REQUIRED_PYTHON} (binary: ${PYTHON_BIN}). Skipping."
else
    info "No suitable Python >= ${REQUIRED_PYTHON} found - installing via deadsnakes PPA…"

    # Add the deadsnakes PPA for latest Python releases
    add-apt-repository -y ppa:deadsnakes/ppa
    apt-get update -qq

    # Install the latest available Python 3 with venv and dev headers
    # Ubuntu 24.04 provides 3.12; the PPA may offer 3.13 or newer.
    TARGET_PY="python3.12"
    apt-get install -y -qq \
        "${TARGET_PY}" \
        "${TARGET_PY}-venv" \
        "${TARGET_PY}-dev" \
        python3-pip

    PYTHON_BIN="${TARGET_PY}"
    PY_VER=$("${PYTHON_BIN}" -c \
        "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')")
    success "Python ${PY_VER} installed (${PYTHON_BIN})."
fi

# Ensure python3-pip is present regardless of the path taken above
if ! cmd_exists pip3 && ! "${PYTHON_BIN}" -m pip --version &>/dev/null; then
    info "pip not found - installing python3-pip…"
    apt-get install -y -qq python3-pip
fi

success "Python binary: $(command -v "${PYTHON_BIN}") → $(${PYTHON_BIN} --version)"

# ==============================================================================
# DJANGO (via pip)
# Official docs: https://docs.djangoproject.com/en/stable/topics/install/
# Installed into a system-level virtual environment to comply with PEP 668
# (Ubuntu 24+ marks the system interpreter as externally managed).
# ==============================================================================
header "Django"

VENV_DIR="/opt/django-env"
DJANGO_BIN="${VENV_DIR}/bin/django-admin"

if [[ -x "${DJANGO_BIN}" ]]; then
    DJANGO_VER=$("${VENV_DIR}/bin/python" -m django --version 2>/dev/null)
    warn "Django ${DJANGO_VER} already installed in ${VENV_DIR}. Skipping."
else
    info "Creating virtual environment at ${VENV_DIR}…"

    # Create a dedicated venv so we never touch the externally-managed interpreter
    "${PYTHON_BIN}" -m venv "${VENV_DIR}"

    info "Upgrading pip inside the venv…"
    "${VENV_DIR}/bin/pip" install --quiet --upgrade pip

    info "Installing latest stable Django…"
    # 'Django' without a version pin always resolves to the latest stable release
    "${VENV_DIR}/bin/pip" install --quiet Django

    DJANGO_VER=$("${VENV_DIR}/bin/python" -m django --version)
    success "Django ${DJANGO_VER} installed in ${VENV_DIR}."
fi

# Create a convenience symlink so `django-admin` is on PATH system-wide
SYMLINK_TARGET="/usr/local/bin/django-admin"
if [[ ! -L "${SYMLINK_TARGET}" ]]; then
    ln -sf "${DJANGO_BIN}" "${SYMLINK_TARGET}"
    info "Symlink created: ${SYMLINK_TARGET} → ${DJANGO_BIN}"
fi

# ==============================================================================
# Summary
# ==============================================================================
header "Installation summary"

echo -e ""
echo -e "  ${GREEN}Docker${RESET}          $(docker --version 2>/dev/null || echo 'n/a')"
echo -e "  ${GREEN}Docker Compose${RESET}  $(docker compose version 2>/dev/null || echo 'n/a')"
echo -e "  ${GREEN}pip${RESET}             $("${VENV_DIR}/bin/python" -m pip --version 2>/dev/null || echo 'n/a')"
echo -e "  ${GREEN}Python${RESET}          $(${PYTHON_BIN} --version 2>/dev/null || echo 'n/a')"
echo -e "  ${GREEN}Django${RESET}          $("${VENV_DIR}/bin/python" -m django --version 2>/dev/null || echo 'n/a') (venv: ${VENV_DIR})"
echo -e ""
echo -e "  To activate the Django venv:"
echo -e "  ${CYAN}source ${VENV_DIR}/bin/activate${RESET}"
echo -e ""
success "All done."