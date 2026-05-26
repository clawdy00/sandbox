# hermes-sandbox

Custom Docker sandbox image for [Hermes Agent](https://github.com/NousResearch/hermes-agent).

Extends the recommended `nikolaik/python-nodejs:python3.11-nodejs20` base with tools the agent frequently needs that aren't in the default image:

| Tool | Purpose |
|------|---------|
| `gh` | GitHub CLI — PRs, issues, releases, secrets |
| `jq` | JSON query/manipulation |
| `yq` | YAML query/manipulation (Go binary, not the Python one) |
| `ripgrep` (`rg`) | Fast recursive search |
| `docker` (CLI) | Drive the host Docker daemon (bind-mount `/var/run/docker.sock`) |

## Usage

In your Hermes `config.yaml`:

```yaml
terminal:
  backend: docker
  docker_image: "ghcr.io/clawdy00/hermes-sandbox:latest"
  docker_forward_env:
    - "GITHUB_TOKEN"
```

Then restart Hermes. The sandbox container will use this image.

## Building locally

```bash
docker build -t hermes-sandbox .
```

## GitHub Actions

Every push to `main` builds the image and publishes to `ghcr.io/clawdy00/hermes-sandbox`.
Access is restricted (private package) — Hermes pulls it using the same `GITHUB_TOKEN`.
