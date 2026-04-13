{ inputs, self, ... }:
let
  vars = import ./../_config.nix;
in
{
  flake.nixosModules.ghosttyNiri =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.myGhosttyNiri
      ];
      hjem.users.${vars.username}.files = {
        ".config-niri/ghostty/config".text =
          let
            theme = import ./_theme.nix { inherit pkgs; };
          in
          ''
            font-family = ${theme.font.name}
            font-size = 12
            background-opacity = 0.9
            foreground = ${builtins.substring 1 6 theme.colors.text}
            background = ${builtins.substring 1 6 theme.colors.base}
            selection-foreground = ${builtins.substring 1 6 theme.colors.text}
            selection-background = ${builtins.substring 1 6 theme.colors.overlay}
            cursor-color = ${builtins.substring 1 6 theme.colors.text}
            cursor-text = ${builtins.substring 1 6 theme.colors.base}
            palette = 0=${builtins.substring 1 6 theme.colors.overlay}
            palette = 8=${builtins.substring 1 6 theme.colors.muted}
            palette = 1=${builtins.substring 1 6 theme.colors.love}
            palette = 9=${builtins.substring 1 6 theme.colors.love}
            palette = 2=${builtins.substring 1 6 theme.colors.pine}
            palette = 10=${builtins.substring 1 6 theme.colors.pine}
            palette = 3=${builtins.substring 1 6 theme.colors.gold}
            palette = 11=${builtins.substring 1 6 theme.colors.gold}
            palette = 4=${builtins.substring 1 6 theme.colors.iris}
            palette = 12=${builtins.substring 1 6 theme.colors.iris}
            palette = 5=${builtins.substring 1 6 theme.colors.iris}
            palette = 13=${builtins.substring 1 6 theme.colors.iris}
            palette = 6=${builtins.substring 1 6 theme.colors.foam}
            palette = 14=${builtins.substring 1 6 theme.colors.foam}
            palette = 7=${builtins.substring 1 6 theme.colors.text}
            palette = 15=${builtins.substring 1 6 theme.colors.text}
          '';
      };
    };

  flake.nixosModules.ghosttyHyprland =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.myGhosttyHyprland
      ];
      hjem.users.${vars.username}.files = {
        ".config-hyprland/ghostty/config".text =
          let
            theme = import ./_theme.nix { inherit pkgs; };
          in
          ''
            font-family = ${theme.font.name}
            font-size = 12
            background-opacity = 0.9
            config-file = /home/${vars.username}/.config/ghostty/noctalia-colors
          '';
      };
    };

  perSystem =
    { pkgs, ... }:
    {
      packages.myGhosttyNiri = inputs.wrapper-modules.lib.wrapPackage {
        inherit pkgs;
        package = pkgs.ghostty;
        env.XDG_CONFIG_HOME = "${vars.home}/.config-niri";
      };
      packages.myGhosttyHyprland = inputs.wrapper-modules.lib.wrapPackage {
        inherit pkgs;
        package = pkgs.ghostty;
        env.XDG_CONFIG_HOME = "${vars.home}/.config-hyprland";
      };
    };
}
