# ==============================================================================
# Dockerfile - isolated test environment for install_dev_tools.sh
# Base image: ubuntu:24.04 (matches target platform)
# ==============================================================================
# Build:
#   docker build -t dev-tools-test . -f Test.DevTools.Dockerfile
#
# Run (interactive, shows full install log):
#   docker run --rm --privileged -it dev-tools-test
#
# Run a one-off command without entering the shell:
#   docker run --rm --privileged dev-tools-test python3 --version
# ==============================================================================

FROM ubuntu:24.04

# Prevent APT and tzdata from prompting for user input during build
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

# ── Layer 1: minimal base utilities needed before the script runs ──────────────
RUN apt-get update -qq && \
    apt-get install -y -qq --no-install-recommends \
        sudo \
        curl \
        gnupg \
        lsb-release \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# ── Layer 2: copy installer into the image ─────────────────────
WORKDIR /opt/installer
COPY install_dev_tools.sh .
RUN chmod +x install_dev_tools.sh

# ── Layer 3: stub systemctl so apt/service calls don't block the build ─────────
# Containers don't run systemd; a no-op shim prevents install errors.
RUN printf '#!/bin/sh\necho "[systemctl-stub] $*"\nexit 0\n' \
        > /usr/local/bin/systemctl && \
    chmod +x /usr/local/bin/systemctl

# ── Layer 4: run the installer ────────────────────────────────────────────────
RUN ./install_dev_tools.sh

# ── Layer 5: add entrypoint script to show installed tools ───
COPY devtools.entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# ── Entrypoint: startup script (verify every tool is reachable) ──────────
ENTRYPOINT ["entrypoint.sh"]