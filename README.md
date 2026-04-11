# Dotfiles Managed by chezmoi

This repository contains my personal dotfiles, managed using [chezmoi](https://www.chezmoi.io/) to ensure a consistent and secure developer environment across machines.

**Target platform:** macOS on Apple Silicon (ARM64) only.

## Getting Started

To set up this environment on a new machine:

1. **Install chezmoi and initialize in one step**

   ```bash
   sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply JeffResc/dotfiles
   ```

   Or if chezmoi is already installed:

   ```bash
   chezmoi init https://github.com/JeffResc/dotfiles
   ```

2. **Configure personal values**

   chezmoi will prompt for the following during `init`:

   | Variable | Description | Values |
   |----------|-------------|--------|
   | `email` | Git commit email address | Your email |
   | `class` | Environment profile | `work` or `personal` |

   These are stored in `~/.config/chezmoi/chezmoi.toml`. To change later:

   ```bash
   chezmoi edit-config
   ```

   Example `chezmoi.toml`:

   ```toml
   [data]
       email = "you@example.com"
       class = "personal"
   ```

3. **Authenticate 1Password CLI**

   Several configs are pulled from 1Password at apply time. Sign in before applying:

   ```bash
   eval $(op signin)
   ```

4. **Apply the configuration**

   ```bash
   chezmoi apply
   ```

   This will:
   - Deploy all dotfiles to your home directory
   - Install Homebrew packages (common + class-specific)
   - Install VSCode extensions
   - Fetch secrets from 1Password for class-specific configs

## Environment Classes

The `class` variable controls which tools and configurations are deployed:

| Area | `personal` | `work` |
|------|-----------|--------|
| Homebrew packages | Homelab tools (talosctl, flux, argocd, cilium, etc.) | Enterprise tools (chainctl, lula, eksctl, etc.) |
| Git signing key | Personal Ed25519 key | Work Ed25519 key |
| SSH config | 1Password agent + OrbStack | 1Password agent + OrbStack |
| Cloud configs | Talos/Kubernetes from 1Password | AWS/Azure/Granted from 1Password |
| Git credential helper | `gh auth git-credential` | `gh auth git-credential` |

## 1Password Integration

Sensitive configs are never stored in this repo. They are fetched at `chezmoi apply` time using the `onepasswordRead` template function:

| File | 1Password Reference | Class |
|------|---------------------|-------|
| `~/.aws/config` | `op://Employee/awsconfig` | work |
| `~/.kube/talos_config` | `op://Homelab Tofu/talos-kubeconfig` | personal |
| `~/.talos/talos_config` | `op://Homelab Tofu/talos-talosconfig` | personal |

Ensure the relevant 1Password vaults are accessible before applying.

## External Dependencies

Some files are fetched from upstream sources rather than vendored in this repo (see `.chezmoiexternal.toml`):

| File | Source | Refresh |
|------|--------|---------|
| `~/.kubectl_aliases` | [ahmetb/kubectl-aliases](https://github.com/ahmetb/kubectl-aliases) | Weekly |

## Day-to-Day Usage

```bash
# See what would change
chezmoi diff

# Edit a managed file (opens in $EDITOR, applies on save)
chezmoi edit ~/.zshrc

# Pull latest dotfiles and apply
chezmoi update

# Add a new file to be managed
chezmoi add ~/.some-config
```

## Tips

- **1Password**: Must be authenticated (`op signin`) before applying secrets.
- **Package changes**: Edit `.chezmoidata/packages.yaml` — the install script re-runs automatically when the file changes.
- **Class switch**: Run `chezmoi edit-config`, change `class`, then `chezmoi apply`.
