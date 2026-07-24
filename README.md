# Dotfiles

Declarative macOS (Apple Silicon) configuration built on [nix-darwin](https://github.com/nix-darwin/nix-darwin) and [home-manager](https://github.com/nix-community/home-manager).

Responsibilities are split three ways:

- **nix-darwin** — macOS system defaults (Dock, Finder, etc.), Nix daemon settings, Touch ID for sudo, system activation scripts
- **home-manager** — CLI tooling from nixpkgs, dotfiles, shell setup (zsh, starship, fzf, zoxide), git config, secret provisioning
- **Homebrew** — GUI apps (casks), Mac App Store apps (via `mas`), and the few CLI tools not in nixpkgs. The Homebrew installation itself and all taps are managed declaratively by [nix-homebrew](https://github.com/zhaofengli/nix-homebrew) with taps pinned as flake inputs (`mutableTaps = false`)

## Layout

```
flake.nix              # inputs, mkDarwin builder, work/personal configurations
hosts/
  personal.nix         # personal-only casks, MAS apps, homelab packages
  work.nix             # work-only brews/packages, Jamf Self Service bootstrap
modules/
  darwin/              # system level: nix settings, macOS defaults, homebrew
  home/                # user level: packages, dotfiles, shell, git, secrets
configs/               # raw config files linked into place by home-manager
```

## Environment Classes

Two configurations are defined in `flake.nix`, selected by the `class` argument. Each sets the username, git identity, and signing key, and imports `hosts/<class>.nix`.

All machines run [Determinate Nix](https://determinate.systems/) (`nix.enable = false` — Determinate manages its own daemon, settings, and GC; custom Nix settings belong in `/etc/nix/nix.custom.conf`).

| Area | `personal` | `work` |
|------|-----------|--------|
| GUI apps | Homebrew casks + MAS apps | Jamf Self Service policies (triggered by an activation script) |
| Extra packages | Homelab tools (talosctl, argocd, cilium-cli, sops, …) | Enterprise tools (chainctl, zarf, uds-cli, eksctl, lula, …) |
| Git | LFS filters, credential store | — |
| Secrets from 1Password | Talos kubeconfig/talosconfig | AWS config |

## Bootstrapping a New Machine

### 0. Prerequisites

- Apple Silicon Mac with admin rights
- Xcode Command Line Tools (provides `git`): `xcode-select --install`
- Signed in to the Mac App Store (required for `masApps` installs)
- Work machines: enrolled in Jamf with Self Service available

### 1. Install Determinate Nix

Use the [macOS graphical installer](https://install.determinate.systems/determinate-pkg/stable/Universal) from [determinate.systems](https://determinate.systems/), or the shell installer:

```bash
curl -fsSL https://install.determinate.systems/nix | sh -s -- install
```

> This config sets `nix.enable = false` (`modules/darwin/default.nix`): Determinate Nix manages its own daemon, settings, and GC, and rejects nix-darwin's native Nix management. Vanilla upstream Nix will also work, but nothing here manages its `nix.conf` or garbage collection.

### 2. Clone this repo

```bash
git clone https://github.com/JeffResc/dotfiles.git ~/.config/nix-darwin
```

The shell aliases and `NH_FLAKE` assume this exact path.

### 3. First activation

```bash
sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake ~/.config/nix-darwin#personal
```

Replace `personal` with `work` for a work machine.

- Homebrew itself is installed by nix-homebrew — no manual Homebrew install is needed.
- Secret provisioning warns and skips if the 1Password CLI isn't available yet; that's expected on first run.

### 4. Post-install

1. Open 1Password, sign in, and enable **SSH agent** and **CLI integration** (Settings → Developer). Required for git commit signing and secret fetching.
2. Authenticate GitHub: `gh auth login` (used for git credentials and Nix access tokens).
3. Re-run activation to fetch secrets: `nh darwin switch`

## Day-to-Day Usage

Aliases defined in `modules/home/shell.nix`:

| Alias | Action |
|-------|--------|
| `nh-switch` | Apply configuration (`nh darwin switch`) |
| `nh-pull` | Pull latest config from git |
| `nh-up` | Pull, then switch |
| `nh-flake` | Update core flake inputs (nixpkgs, nix-darwin, home-manager, kubectl-aliases) |
| `nh-flake-up` | Update core inputs, then switch |
| `nh-bump` | Update core inputs, commit and push `flake.lock` |

Other useful commands:

```bash
nix flake update   # update ALL inputs, including pinned Homebrew taps
nix fmt            # format nix files (nixfmt-rfc-style)
```

## 1Password Integration

Sensitive configs are fetched at activation time via the `op` CLI (`modules/home/secrets.nix`):

| File | 1Password Reference | Class |
|------|---------------------|-------|
| `~/.aws/config` | `op://Employee/awsconfig` | work |
| `~/.kube/talos_config` | `op://Homelab Tofu/talos-kubeconfig` | personal |
| `~/.talos/talos_config` | `op://Homelab Tofu/talos-talosconfig` | personal |
