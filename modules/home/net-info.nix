{ pkgs, ... }:
let
  net-info = pkgs.callPackage ../../pkgs/net-info.nix { };
in
{
  home.packages = [ net-info ];

  launchd.agents.net-info = {
    enable = true;
    config = {
      ProgramArguments = [ "${net-info}/Applications/Net Info.app/Contents/MacOS/Net Info" ];
      RunAtLoad = true;
    };
  };
}
