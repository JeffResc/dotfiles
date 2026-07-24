{ username, pkgs, ... }:
{
  imports = [
    ./homebrew.nix
    ./defaults.nix
  ];

  # All machines run Determinate Nix, which manages its own daemon,
  # settings, and GC and rejects nix-darwin's native nix management.
  # Custom settings belong in /etc/nix/nix.custom.conf.
  nix.enable = false;

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
      if grep -q '^access-tokens' /etc/nix/nix.custom.conf 2>/dev/null; then
        sed -i '' 's|^access-tokens.*|access-tokens = github.com='"$TOKEN"'|' /etc/nix/nix.custom.conf
      else
        echo "access-tokens = github.com=$TOKEN" >> /etc/nix/nix.custom.conf
      fi
    fi
  '';

  nixpkgs.hostPlatform = "aarch64-darwin";

  system.stateVersion = 6;
}
