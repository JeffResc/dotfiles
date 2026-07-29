# Global Instructions

## Problem Solving

- When something fails, stop. Read the error. Understand the root cause before changing anything.
- Don't remove or change code you can't explain — understand why it exists first.
- Prefer editing existing files over creating new ones.
- State assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them — don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

## Verifying Assumptions

- Verify every assumption before acting on it. Do not guess, infer, or rely on memory.
- Ground answers in concrete truths backed by evidence — read the file, run the command, check the output, inspect the source.
- Prefer primary evidence over recall: confirm APIs, flags, paths, versions, and behavior against the actual code, docs, or tooling rather than assuming.
- When something cannot be verified from available evidence, stop and ask the user rather than assuming.
- State what is confirmed versus unconfirmed. Do not present an assumption as fact.

## Git

- Never run state-changing git commands (commit, push, merge, rebase, reset, etc.) unless the user explicitly asks.
- If asked to commit, use conventional commit format. Message must be a single sentence — no paragraphs, no bullet points, no co-author trailers.
- Commits are signed via 1Password SSH agent — never bypass or reconfigure signing.
- Never skip pre-commit hooks (`--no-verify`).

## Pull Requests & Issues

- Use `gh` to create PRs or issues only when the user explicitly requests it.
- Follow the repo's templates (e.g., `.github/pull_request_template.md`, `.github/ISSUE_TEMPLATE/`) when available.
- PR titles must follow conventional commit format.
- Write descriptions in Simplified Technical English per [ASD-STE100](https://asd-ste100.org/): short sentences, active voice, approved words, no ambiguity.

## CLI Tool Preferences

- Use `fd` instead of `find`.
- Use `rg` (ripgrep) instead of `grep`.
- Use `bat` instead of `cat` for file display.
- Use `eza` instead of `ls`.
- Use `dust` instead of `du`.
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
- No features beyond what was asked. No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.

## Surgical Changes

- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it — don't delete it.
- Remove imports/variables/functions that your changes made unused.
- Don't remove pre-existing dead code unless asked.
- Every changed line should trace directly to the user's request.

## Goal-Driven Execution

- Transform tasks into verifiable goals before implementing.
- For multi-step tasks, state a brief plan with verification checks per step.
- Strong success criteria let you loop independently. Weak criteria require clarification — ask for it.

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
