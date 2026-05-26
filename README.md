# hermes-sandbox

Custom Docker sandbox image for [Hermes Agent](https://github.com/NousResearch/hermes-agent).

Extends `nikolaik/python-nodejs:python3.11-nodejs20` with:

| Tool | Purpose |
|------|---------|
| `gh` | GitHub CLI — PRs, issues, releases, secrets |
| `jq` | JSON query/manipulation |
| `yq` | YAML processing (mikefarah/yq, Go binary) |
| `ripgrep` | Fast recursive search |

## Usage

```bash
hermes config set terminal.docker_image "ghcr.io/clawdy00/hermes-sandbox:latest"
```

That's it. Restart Hermes and the sandbox uses this image. Public on `ghcr.io` — no auth needed.
