{ ... }:
{
  imports = [
    ./packages.nix
    ./dotfiles.nix
    ./shell.nix
    ./git.nix
    ./secrets.nix
  ];

  home.stateVersion = "24.11";
}
