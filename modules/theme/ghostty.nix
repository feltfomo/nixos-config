{ inputs, self, ... }:
{
  flake.nixosModules.ghosttyNiri =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.myGhosttyNiri
      ];
    };

  flake.nixosModules.ghosttyHyprland =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.myGhosttyHyprland
      ];
    };

  perSystem =
    { pkgs, ... }:
    let
      theme = import ./_theme.nix { inherit pkgs; };
      baseConf = ''
        # font
        font-family = ${theme.font.name}
        font-size = 12

        # window
        background-opacity = 0.9

        # colors
        foreground = ${builtins.substring 1 6 theme.colors.text}
        background = ${builtins.substring 1 6 theme.colors.base}
        selection-foreground = ${builtins.substring 1 6 theme.colors.text}
        selection-background = ${builtins.substring 1 6 theme.colors.overlay}
        cursor-color = ${builtins.substring 1 6 theme.colors.text}
        cursor-text = ${builtins.substring 1 6 theme.colors.base}

        # black
        palette = 0=${builtins.substring 1 6 theme.colors.overlay}
        palette = 8=${builtins.substring 1 6 theme.colors.muted}
        # red
        palette = 1=${builtins.substring 1 6 theme.colors.love}
        palette = 9=${builtins.substring 1 6 theme.colors.love}
        # green
        palette = 2=${builtins.substring 1 6 theme.colors.pine}
        palette = 10=${builtins.substring 1 6 theme.colors.pine}
        # yellow
        palette = 3=${builtins.substring 1 6 theme.colors.gold}
        palette = 11=${builtins.substring 1 6 theme.colors.gold}
        # blue
        palette = 4=${builtins.substring 1 6 theme.colors.iris}
        palette = 12=${builtins.substring 1 6 theme.colors.iris}
        # magenta
        palette = 5=${builtins.substring 1 6 theme.colors.iris}
        palette = 13=${builtins.substring 1 6 theme.colors.iris}
        # cyan
        palette = 6=${builtins.substring 1 6 theme.colors.foam}
        palette = 14=${builtins.substring 1 6 theme.colors.foam}
        # white
        palette = 7=${builtins.substring 1 6 theme.colors.text}
        palette = 15=${builtins.substring 1 6 theme.colors.text}
      '';
      ghosttyConfNiri = pkgs.writeText "ghostty" baseConf;
      ghosttyConfHyprland = pkgs.writeText "ghostty" ''
        # colors managed at runtime by noctalia matugen
        config-file = /home/feltfomo/.config/ghostty/noctalia-colors
        # font
        font-family = ${theme.font.name}
        font-size = 12
        # window
        background-opacity = 0.9
      '';
    in
    {
      packages.myGhosttyNiri = inputs.wrapper-modules.lib.wrapPackage {
        inherit pkgs;
        package = pkgs.ghostty;
        env.GHOSTTY_CONFIG_FILE = "${ghosttyConfNiri}";
      };
      packages.myGhosttyHyprland = inputs.wrapper-modules.lib.wrapPackage {
        inherit pkgs;
        package = pkgs.ghostty;
        env.GHOSTTY_CONFIG_FILE = "${ghosttyConfHyprland}";
      };
    };
}
