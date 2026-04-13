{ ... }:
let vars = import ./../_config.nix;
in {
  flake.nixosModules.obsidian = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.obsidian ];

    hjem.users.${vars.username}.files = {
      ".config/obsidian/obsidian.json".text = builtins.toJSON {
        vaults = {};
      };
    };

    nixpkgs.config.allowUnfree = true;
  };
}
