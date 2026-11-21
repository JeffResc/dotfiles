{ config
, pkgs
, homebrew-core
, homebrew-cask
, homebrew-bundle
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
      "homebrew/homebrew-cask" = homebrew-cask;
      "homebrew/homebrew-bundle" = homebrew-bundle;
      "hashicorp/homebrew-tap" = homebrew-hashicorp;
    };
  };

  fonts.packages = [ pkgs.nerd-fonts.fira-code ];

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "uninstall";
    };
    global.autoUpdate = false;

    taps = builtins.attrNames config.nix-homebrew.taps;

    brews = [
      "mas"
      "pinentry-mac"
    ];

    casks = [
      "1password-cli"
      "bentobox"
      "ghostty"
      "macpacker"
      "openlogi"
    ];

    masApps = {
      "WireGuard" = 1451685025;
    };
  };
}
