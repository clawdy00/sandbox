# hermes-sandbox

Custom Docker sandbox image for [Hermes Agent](https://github.com/NousResearch/hermes-agent). Public — no auth needed to pull.

Extends the recommended `nikolaik/python-nodejs:python3.11-nodejs20` base with tools the agent frequently needs that aren't in the default image:

| Tool | Purpose |
|------|---------|
| `gh` | GitHub CLI — PRs, issues, releases, secrets |
| `jq` | JSON query/manipulation |
| `yq` | YAML query/manipulation (mikefarah/yq, the Go binary not the Python one) |
| `ripgrep` (`rg`) | Fast recursive search |

## Usage

In your Hermes `config.yaml`:

```yaml
terminal:
  backend: docker
  docker_image: "ghcr.io/clawdy00/hermes-sandbox:latest"
  docker_forward_env:
    - "GITHUB_TOKEN"
```

Then restart Hermes. The sandbox container will use this image. No registry credentials needed — it's public on `ghcr.io`.

## What's NOT in this image

- **Docker CLI** — building images inside a container via the host daemon socket is a security risk. If the agent needs to build container images, [kaniko](https://github.com/GoogleContainerTools/kaniko) (daemonless) is the right tool. Not pre-installed — added when/if needed.
- **Language toolchains beyond the base image** — Python 3.11 and Node.js 20 are already in the base. Additional runtimes added on demand.

## GitHub Actions

Every push to `main` builds and publishes to `ghcr.io/clawdy00/hermes-sandbox:latest`.
