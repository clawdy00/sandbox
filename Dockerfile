# Custom AI agent sandbox — extra tools on top of the Nikolaik base
FROM nikolaik/python-nodejs:python3.11-nodejs20

ENV CARGO_HOME=/usr/local/cargo \
    RUSTUP_HOME=/usr/local/rustup \
    PATH=/usr/local/cargo/bin:$PATH

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

# Install a current stable Rust toolchain via rustup. Debian cargo/rustc can lag
# behind dependency MSRVs, so the sandbox keeps rustup-managed stable available.
RUN RUSTUP_VERSION="1.28.2" \
    && ARCH=$(uname -m) \
    && case "$ARCH" in \
         x86_64)  RUSTUP_TARGET="x86_64-unknown-linux-gnu" ;; \
         aarch64) RUSTUP_TARGET="aarch64-unknown-linux-gnu" ;; \
         *) echo "Unsupported arch: $ARCH"; exit 1 ;; \
       esac \
    && curl -fsSL "https://static.rust-lang.org/rustup/archive/${RUSTUP_VERSION}/${RUSTUP_TARGET}/rustup-init" -o /tmp/rustup-init \
    && chmod +x /tmp/rustup-init \
    && /tmp/rustup-init -y --profile minimal --default-toolchain stable \
    && rm /tmp/rustup-init \
    && chmod -R a+rwX "$RUSTUP_HOME" "$CARGO_HOME" \
    && cargo --version \
    && rustc --version \
    && rustup --version

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
    && echo -n "uv: "     && uv --version \
    && echo -n "cargo: "  && cargo --version \
    && echo -n "rustc: "  && rustc --version \
    && echo -n "rustup: " && rustup --version
