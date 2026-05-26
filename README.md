# sandbox

Custom AI agent sandbox image.

Extends `nikolaik/python-nodejs:python3.11-nodejs20` with:

| Tool | Purpose |
|------|---------|
| `gh` | GitHub CLI |
| `jq` | JSON processing |
| `yq` | YAML processing (mikefarah/yq) |
| `ripgrep` | Fast recursive search |

## Usage

```bash
# Set as sandbox image:
docker pull ghcr.io/clawdy00/sandbox:latest
```

Public on `ghcr.io` — no auth needed.
