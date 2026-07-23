{ ... }:
{
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "uninstall";
    };
    global.autoUpdate = false;

    taps = [
      "defenseunicorns/tap"
    ];

    brews = [
      "ansible"
      "apko"
      "atmos"
      "checkov"
      "grype"
      "mas"
      "melange"
      "pinentry-mac"
      "syft"
      "trivy"
      "uv"
    ];

    casks = [
      "1password-cli"
      "bentobox"
      "claude-code"
      "codex"
      "font-fira-code-nerd-font"
      "ghostty"
      "qdirstat"
    ];

    masApps = {
      "WireGuard" = 1451685025;
      "Windows App" = 1295203466;
    };
  };
}
