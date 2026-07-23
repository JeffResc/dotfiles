{ class, config, lib, ... }:
{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      l = "eza";
      kctx = "kubectx";
      kns = "kubens";
      kubectl = "kubecolor";
      watch = "viddy";
      assume = ". assume";
      nh-pull = "git -C ~/.config/nix-darwin pull";
      nh-up = "git -C ~/.config/nix-darwin pull && nh darwin switch";
      nh-flake = "nix flake update nixpkgs nix-darwin home-manager kubectl-aliases --flake ~/.config/nix-darwin";
      nh-flake-up = "nix flake update nixpkgs nix-darwin home-manager kubectl-aliases --flake ~/.config/nix-darwin && nh darwin switch";
    };
    initContent = lib.mkMerge [
      (lib.mkOrder 100 ''
        eval "$(/opt/homebrew/bin/brew shellenv)"
      '')
      (lib.mkOrder 550 ''
        export KUBE_EDITOR="$HOME/.local/bin/kube-edit.sh"
        export DO_NOT_TRACK=1

        eval "$(fnm env --use-on-cd --shell zsh)"

        [ -f ~/.kubectl_aliases ] && source ~/.kubectl_aliases
        source "$HOME/.azure-select.sh"

        alias op_account='export OP_ACCOUNT=$(op account ls --format=json | jq -r ".[0].account_uuid")'

        nh-bump() {
          local repo="$HOME/.config/nix-darwin"
          local stashed=0
          local stamp
          stamp=$(date +%Y-%m-%d)

          if ! git -C "$repo" diff --quiet HEAD 2>/dev/null; then
            echo "→ stashing dirty changes"
            git -C "$repo" stash push -u -m "nh-bump auto-stash $stamp" || return 1
            stashed=1
          fi

          echo "→ updating flake inputs"
          if ! nix flake update nixpkgs nix-darwin home-manager kubectl-aliases --flake "$repo"; then
            [ $stashed -eq 1 ] && git -C "$repo" stash pop
            return 1
          fi

          if git -C "$repo" diff --quiet HEAD -- flake.lock; then
            echo "→ no flake.lock changes"
          else
            echo "→ committing"
            git -C "$repo" add flake.lock
            git -C "$repo" commit -m "chore: flake update $stamp" || {
              [ $stashed -eq 1 ] && git -C "$repo" stash pop
              return 1
            }
            echo "→ pushing"
            git -C "$repo" push || echo "  push failed (commit is local)"
          fi

          if [ $stashed -eq 1 ]; then
            echo "→ restoring stash"
            git -C "$repo" stash pop || echo "  stash pop had conflicts, resolve manually"
          fi
        }
      '')
      (lib.mkOrder 1500 ''
        compdef kubecolor=kubectl
      '')
      (lib.mkIf (class == "personal") (lib.mkOrder 600 ''
        export KUBECONFIG=~/.kube/talos_config
        export TALOSCONFIG=~/.talos/talos_config
      ''))
    ];
    envExtra = ''
      export PATH="$HOME/.local/bin:$HOME/go/bin:$HOME/.cargo/bin:''${KREW_ROOT:-$HOME/.krew}/bin:$HOME/.uds/bin:$PATH"
    '';
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = builtins.fromTOML (builtins.readFile ../../configs/starship.toml);
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [ "--cmd" "cd" ];
  };

  programs.bat = {
    enable = true;
    config = {
      style = "plain";
      paging = "never";
    };
  };

  programs.bottom.enable = true;
  programs.jq.enable = true;
  programs.k9s.enable = true;
  programs.eza.enable = true;
  programs.ripgrep.enable = true;

  programs.go = {
    enable = true;
    env.GOPATH = "${config.home.homeDirectory}/go";
  };

  programs.gh.enable = true;

  home.sessionVariables = {
    NH_FLAKE = "$HOME/.config/nix-darwin#${class}";
  };
}
