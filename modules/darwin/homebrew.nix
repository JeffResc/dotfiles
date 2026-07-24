{ config, ... }:
{
  system.activationScripts.preActivation.text = ''
    if [ -x /opt/homebrew/bin/brew ]; then
      for tap in $(sudo -u ${config.system.primaryUser} /opt/homebrew/bin/brew tap 2>/dev/null); do
        sudo -u ${config.system.primaryUser} /opt/homebrew/bin/brew trust "$tap" >/dev/null 2>&1 || true
      done
    fi
  '';

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
      "mas"
      "pinentry-mac"
    ];

    casks = [
      "1password-cli"
      "bentobox"
      "claude-code"
      "font-fira-code-nerd-font"
      "ghostty"
    ];

    masApps = {
      "WireGuard" = 1451685025;
      "Windows App" = 1295203466;
    };
  };
}
