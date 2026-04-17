{ ... }: {
  flake.nixosModules.fonts = { pkgs, ... }:
  let vars = import ./../_config.nix;
  in {
    fonts = {
      packages = [
        pkgs.nerd-fonts.jetbrains-mono
        pkgs.inter
      ];
      fontconfig.defaultFonts = {
        monospace = [ vars.font.mono ];
        sansSerif = [ vars.font.sans ];
        serif     = [ vars.font.sans ];
      };
    };
  };
}
