{ class, username, pkgs, ... }:
{
  imports = [
    ./homebrew.nix
    ./defaults.nix
  ];

  nix = {
    # Determinate Nix (used on personal) manages its own daemon and
    # rejects nix-darwin's native nix management.
    enable = class != "personal";
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ username ];
      warn-dirty = false;
    };
    gc = {
      automatic = class != "personal";
      interval = { Weekday = 7; Hour = 3; Minute = 0; };
      options = "--delete-older-than 30d";
    };
    optimise.automatic = class != "personal";
    extraOptions = ''
      !include /etc/nix/access-tokens.conf
    '';
  };

  environment.systemPackages = [ pkgs.nh ];

  system.primaryUser = username;
  users.users.${username}.home = "/Users/${username}";

  security.pam.services.sudo_local.touchIdAuth = true;

  system.activationScripts.postActivation.text = ''
    sudo -u ${username} --set-home /bin/sh -c '/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u'
  '';

  system.activationScripts.nixAccessTokens.text = ''
    TOKEN=$(sudo -u ${username} --set-home /bin/sh -c '${pkgs.gh}/bin/gh auth token 2>/dev/null || true')
    if [ -n "$TOKEN" ]; then
      echo "access-tokens = github.com=$TOKEN" > /etc/nix/access-tokens.conf
      chmod 600 /etc/nix/access-tokens.conf
    fi
  '';

  nixpkgs.hostPlatform = "aarch64-darwin";

  system.stateVersion = 6;
}
