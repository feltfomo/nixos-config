{
  description = "fomonix nixos with home manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia-shell = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dms = {
      url = "github:AvengeMedia/DankMaterialShell/stable";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    silentSDDM = {
      url = "github:uiriansan/SilentSDDM";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri-flake = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri-blur = {
      url = "github:Naxdy/niri";
      flake = false;
    };

    # --- walker ---
    elephant.url = "github:abenz1267/elephant";
    walker = {
      url = "github:abenz1267/walker";
      inputs.elephant.follows = "elephant";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      noctalia-shell,
      zen-browser,
      niri-flake,
      walker, # added
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations.fomonix = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          ./configuration.nix
          niri-flake.nixosModules.niri
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.backupFileExtension = "backup";
            home-manager.users.zynth = {
              imports = [ ./home.nix ];
              systemd.user.startServices = "sd-switch";
            };
          }
          {
            programs.niri = {
              enable = true;
              package = pkgs.niri.overrideAttrs (old: {
                src = inputs.niri-blur;
                cargoHash = null;
                cargoDeps = pkgs.rustPlatform.importCargoLock {
                  lockFile = "${inputs.niri-blur}/Cargo.lock";
                  allowBuiltinFetchGit = true;
                };
                doCheck = false;
                doInstallCheck = false;
              });
            };
          }
          # --- walker binary cache ---
          {
            nix.settings = {
              extra-substituters = [
                "https://walker.cachix.org"
                "https://walker-git.cachix.org"
              ];
              extra-trusted-public-keys = [
                "walker.cachix.org-1:fG8q+uAaMqhsMxWjwvk0IMb4mFPFLqHjuvfwQxE4oJM="
                "walker-git.cachix.org-1:vmC0ocfPWh0S/vRAQGtChuiZBTAe4wiKDeyyXM0/7pM="
              ];
            };
          }
        ];
      };

      devShells.${system} = {
        java = import ./modules/dev/java.nix { inherit pkgs; };
        default = self.devShells.${system}.java;
      };
    };
}
