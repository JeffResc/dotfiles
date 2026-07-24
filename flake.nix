{
  description = "Jeff's nix-darwin configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
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
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    homebrew-hashicorp = {
      url = "github:hashicorp/homebrew-tap";
      flake = false;
    };
  };

  outputs = inputs@{ self, nixpkgs, nix-darwin, home-manager, kubectl-aliases, du-packages, nix-homebrew, ... }:
  let
    commonModules = [
      ./modules/darwin
      home-manager.darwinModules.home-manager
      nix-homebrew.darwinModules.nix-homebrew
    ];
    mkDarwin = { class, username, userEmail, signingKey }: nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      specialArgs = {
        inherit class username userEmail signingKey kubectl-aliases du-packages;
        inherit (inputs)
          homebrew-core
          homebrew-cask
          homebrew-bundle
          homebrew-hashicorp
          ;
      };
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
