{ inputs, ... }:
{
  flake.nixosModules.spicetify = { pkgs, lib, ... }:
  let
    spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  in {
    imports = [ inputs.spicetify-nix.nixosModules.default ];

    nixpkgs.config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [ "spotify" ];

    programs.spicetify = {
      enable = true;
      theme = spicePkgs.themes.hazy;
      enabledExtensions = with spicePkgs.extensions; [
        adblock
        hidePodcasts
        shuffle
      ];
    };
  };
}
