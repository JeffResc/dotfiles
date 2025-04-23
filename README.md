# 🛠️ Dotfiles Managed by chezmoi

This repository contains my personal dotfiles, managed using [chezmoi](https://www.chezmoi.io/) to ensure a consistent and secure developer environment across machines.

## 🚀 Getting Started

To set up this environment on a new machine:

1. **Install chezmoi**

   ```bash
   brew install chezmoi
   ```

2. **Initialize chezmoi**

   Start by cloning this repo using chezmoi:

   ```bash
   chezmoi init https://github.com/JeffResc/dotfiles
   ```

3. **Configure personal values**

   Edit the config file:

   ```bash
   chezmoi edit-config
   ```

   Update fields such as:

   - `email` – used for git config
   - `class` – set to either `work` or `personal` to tailor the installation

4. **Apply the configuration and initialize shell environment**

   ```bash
   chezmoi apply
   ```

   > 🔧 The `chezmoi apply` command applies all the dotfiles from the repository and sets up your shell environment, installs Homebrew packages, applies VSCode extensions, and configures system defaults. It’s the one-stop bootstrap script for your setup.

## 🔐 Sensitive Configs & 1Password Integration

Certain files, such as `.aws/config`, are managed via 1Password and templated using `chezmoi`'s `onepasswordDocument` function. These secrets are not stored in plaintext or committed to this repo. Ensure that you have 1Password CLI (`op`) installed and signed in before running `chezmoi apply`.

## 🧼 Environment Classes

You can toggle between `work` and `personal` setups by updating the `class` value in your chezmoi config. This influences:

- Which tools are installed (e.g., `defenseunicorns/tap` for work)
- Git signing keys and credential managers
- Cloud and infra tools included

---

## 📎 Tips

- **1Password integration**: Ensure `op` is authenticated before applying secrets.
- **Update configs**: Use `chezmoi diff`, `chezmoi edit`, and `chezmoi apply` to manage updates cleanly.
