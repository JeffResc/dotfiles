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
      nh-flake = "nix flake update --flake ~/.config/nix-darwin";
      nh-flake-up = "nix flake update --flake ~/.config/nix-darwin && nh darwin switch";
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
