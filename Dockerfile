# Hermes Agent Sandbox — custom image extending the recommended base
# Build: docker build -t hermes-sandbox .
# Hermes config: terminal.docker_image: "ghcr.io/clawdy00/hermes-sandbox:latest"
# Public image — no auth needed to pull.

FROM nikolaik/python-nodejs:python3.11-nodejs20

USER root

# Install core CLI tools the agent needs but aren't in the base image
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        gh \
        jq \
        ripgrep \
    && rm -rf /var/lib/apt/lists/*

# Install yq (the Go binary — much faster than the Python pip version)
# The release tarball contains ./yq_linux_amd64, ./yq_linux_arm64, etc.
RUN YQ_VERSION="v4.47.1" \
    && ARCH=$(uname -m) \
    && case "$ARCH" in \
         x86_64)  BINARY="yq_linux_amd64" ;; \
         aarch64) BINARY="yq_linux_arm64" ;; \
         *) echo "Unsupported arch: $ARCH"; exit 1 ;; \
       esac \
    && curl -fsSL "https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/${BINARY}.tar.gz" \
       | tar xz -C /tmp/ \
    && mv "/tmp/${BINARY}" /usr/local/bin/yq \
    && chmod +x /usr/local/bin/yq \
    && yq --version

# Restore the non-root user from the base image
USER 1000

# Verify toolchain
RUN echo "=== Hermes Sandbox Toolchain ===" \
    && echo -n "gh: "     && gh --version | head -1 \
    && echo -n "jq: "     && jq --version \
    && echo -n "yq: "     && yq --version \
    && echo -n "rg: "     && rg --version \
    && echo -n "git: "    && git --version \
    && echo -n "node: "   && node --version \
    && echo -n "python: " && python3 --version \
    && echo -n "npm: "    && npm --version \
    && echo -n "pip: "    && pip --version \
    && echo -n "uv: "     && uv --version
