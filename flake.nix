{
  description = "fomonix – NixOS with Home Manager and Flake Packages";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    zen-browser.url = "github:youwen5/zen-browser-flake";
    swww.url = "github:LGFae/swww";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in {
      nixosConfigurations.fomonix = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs system pkgs; };
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.users.zynth = { pkgs, inputs, ... }: {
              home.username = "zynth";
              home.homeDirectory = "/home/zynth";
              home.stateVersion = "25.05";
              programs.zsh.enable = true;
              home.packages = [
                inputs.zen-browser.packages.${pkgs.system}.default
              ];
            };
          }
        ];
      };
    };
}
