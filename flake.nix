{
  description = "Jeff's nix-darwin configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    kubectl-aliases = {
      url = "github:ahmetb/kubectl-aliases";
      flake = false;
    };
    du-packages = {
      url = "github:defenseunicorns-labs/nix-packages";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager, kubectl-aliases, du-packages, ... }:
  let
    commonModules = [
      ./modules/darwin
      home-manager.darwinModules.home-manager
    ];
    mkDarwin = { class, username, userEmail, signingKey }: nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      specialArgs = { inherit class username userEmail signingKey kubectl-aliases du-packages; };
      modules = commonModules ++ [
        ./hosts/${class}.nix
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "hm-backup";
            users.${username} = import ./modules/home;
            extraSpecialArgs = { inherit class username userEmail signingKey kubectl-aliases du-packages; };
          };
        }
      ];
    };
  in {
    formatter.aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.nixfmt-rfc-style;

    darwinConfigurations = {
      work = mkDarwin {
        class = "work";
        username = "jeffr";
        userEmail = "jeffr@defenseunicorns.com";
        signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMhMqkkJzMyUxdoKRMMeJ8uk1YhukiWst1TJy75sleRC";
      };
      personal = mkDarwin {
        class = "personal";
        username = "jeff";
        userEmail = "jeff@jeffresc.dev";
        signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPd7YTi+a7/xbOv53XhAa9qImiq3Yv3z8jOzInv9q41a";
      };
    };
  };
}
