{ config
, homebrew-core
, homebrew-hashicorp
, ...
}:
{
  nix-homebrew = {
    enable = true;
    user = config.system.primaryUser;
    autoMigrate = true;
    mutableTaps = false;
    taps = {
      "homebrew/homebrew-core" = homebrew-core;
      "hashicorp/homebrew-tap" = homebrew-hashicorp;
    };
  };

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "uninstall";
    };
    global.autoUpdate = false;

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
