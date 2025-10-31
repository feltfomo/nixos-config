{
  description = "fomonix – NixOS with Home Manager and Zen Browser";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    zen-browser.url = "github:youwen5/zen-browser-flake";
  };

  outputs = { self, nixpkgs, home-manager, zen-browser, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in {
      nixosConfigurations.fomonix = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./configuration.nix

          ({ ... }: {
            environment.systemPackages = [
              zen-browser.packages.${system}.default
            ];
          })

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.zynth = { pkgs, ... }: {
              home.username = "zynth";
              home.homeDirectory = "/home/zynth";
              programs.zsh.enable = true;
              home.packages = [
                zen-browser.packages.${system}.default
              ];
            };
          }
        ];
      };
    };
}
