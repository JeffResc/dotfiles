# Global Instructions

## Problem Solving

- When something fails, stop. Read the error. Understand the root cause before changing anything.
- Don't remove or change code you can't explain — understand why it exists first.
- Prefer editing existing files over creating new ones.

## Git

- Never run state-changing git commands (commit, push, merge, rebase, reset, etc.) unless the user explicitly asks.
- If asked to commit, use conventional commit format. Message must be a single sentence — no paragraphs, no bullet points, no co-author trailers.
- Commits are signed via 1Password SSH agent — never bypass or reconfigure signing.
- Never skip pre-commit hooks (`--no-verify`).

## CLI Tool Preferences

- Use `fd` instead of `find`.
- Use `rg` (ripgrep) instead of `grep`.
- Use `bat` instead of `cat` for file display.
- Use `eza` instead of `ls`.
- Use `dust` instead of `du`.
- Use `btm` (bottom) instead of `top`/`htop`.
- Use `jq` for JSON processing; `yq` for YAML.
- Use `gh` for GitHub operations (PRs, issues, checks).
- Use `uv` for Python project/package management, not pip.
- Use `opentofu` instead of `terraform`.

## Kubernetes

- Use `kubecolor` instead of raw `kubectl` (aliased as `kubectl`).
- Use `kubectx`/`kubens` for context and namespace switching.
- Use `stern` for log tailing across pods.
- Use `k9s` for interactive cluster exploration.
- Use `helm` for chart operations; `helm-docs` for documentation.
- Use `grpcurl` for gRPC service debugging.

## Secrets & Credentials

- Never output, log, or hardcode secrets, tokens, or credentials.
- AWS credentials are managed via `granted` (`assume` alias) — never set AWS keys directly.
- 1Password CLI (`op`) is available for secret retrieval when needed.

## Code Style

- Be concise. No filler, no summaries of what you just did.
- Prefer simple, readable code. No over-engineering or premature abstraction.
- Use early returns over nested conditionals.
- Let errors surface — no silent fallbacks.

## Linting

- Shell scripts: validate with `shellcheck`.
- Go: lint with `golangci-lint`.
- YAML: validate with `yamllint`.
- Protobuf: lint with `buf lint`.
- Terraform/OpenTofu: lint with `tflint`.

## Infrastructure

- This machine is managed with nix-darwin and home-manager. Config lives at `~/.config/nix-darwin`.
- Shell is zsh with starship prompt, fzf, and zoxide (`cd` is aliased to zoxide).
- Container tools: docker, dive, k3d, OrbStack.
- Supply chain: cosign, crane, syft, grype, trivy, oras, skopeo.
- IaC: opentofu, atmos, tflint, terraform-docs.
