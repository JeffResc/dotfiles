# Dotfiles

nix-darwin + home-manager configuration for macOS on Apple Silicon.

**Homebrew** manages all packages declaratively through nix-darwin's homebrew module. **home-manager** manages dotfiles. **nix-darwin** manages macOS system defaults and nix settings.

## Getting Started

1. **Install Nix**

   ```bash
   curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh
   ```

2. **Install Homebrew**

   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

3. **Bootstrap nix-darwin**

   ```bash
   nix run nix-darwin -- switch --flake github:JeffResc/dotfiles#work
   ```

   Replace `work` with `personal` for a personal machine.

4. **Authenticate 1Password CLI**

   ```bash
   eval $(op signin)
   ```

   Then re-run to fetch secrets:

   ```bash
   nh darwin switch
   ```

## Environment Classes

The `class` variable controls which tools and configurations are deployed:

| Area | `personal` | `work` |
|------|-----------|--------|
| Homebrew packages | Homelab tools (talosctl, flux, argocd, cilium, etc.) | Enterprise tools (chainctl, lula, eksctl, etc.) |
| Git signing key | Personal Ed25519 key | Work Ed25519 key |
| Cloud configs | Talos/Kubernetes from 1Password | AWS/Azure/Granted from 1Password |

## Day-to-Day Usage

```bash
# Apply configuration changes
nh darwin switch

# Update flake inputs (nix, home-manager, etc.)
nix flake update

# Format nix files
nix fmt
```

## 1Password Integration

Sensitive configs are fetched at activation time via the `op` CLI:

| File | 1Password Reference | Class |
|------|---------------------|-------|
| `~/.aws/config` | `op://Employee/awsconfig` | work |
| `~/.kube/talos_config` | `op://Homelab Tofu/talos-kubeconfig` | personal |
| `~/.talos/talos_config` | `op://Homelab Tofu/talos-talosconfig` | personal |
