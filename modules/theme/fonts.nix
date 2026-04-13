{ ... }: {
  flake.nixosModules.fonts = { pkgs, ... }:
  let theme = import ./_theme.nix { inherit pkgs; };
  in {
    fonts = {
      packages = [ theme.font.package theme.sansFont.package ];
      fontconfig.defaultFonts = {
        monospace = [ theme.font.name ];
        sansSerif = [ theme.sansFont.name ];
        serif = [ theme.sansFont.name ];
      };
    };
  };
}
