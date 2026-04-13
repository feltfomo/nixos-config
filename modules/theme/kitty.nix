{ inputs, self, ... }:
{
  flake.nixosModules.kittyNiri = { pkgs, ... }: {
    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.myKittyNiri
    ];
  };

  flake.nixosModules.kittyHyprland = { pkgs, ... }: {
    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.myKittyHyprland
    ];
  };

  perSystem = { pkgs, ... }:
  let
    theme = import ./_theme.nix { inherit pkgs; };
    baseConf = ''
      # colors
      foreground              ${theme.colors.text}
      background              ${theme.colors.base}
      selection_foreground    ${theme.colors.text}
      selection_background    ${theme.colors.overlay}
      cursor                  ${theme.colors.text}
      cursor_text_color       ${theme.colors.base}
      url_color               ${theme.colors.iris}
      active_tab_foreground   ${theme.colors.text}
      active_tab_background   ${theme.colors.overlay}
      inactive_tab_foreground ${theme.colors.muted}
      inactive_tab_background ${theme.colors.base}
      active_border_color     ${theme.colors.pine}
      inactive_border_color   ${theme.colors.overlay}
      # black
      color0  ${theme.colors.overlay}
      color8  ${theme.colors.muted}
      # red
      color1  ${theme.colors.love}
      color9  ${theme.colors.love}
      # green
      color2  ${theme.colors.pine}
      color10 ${theme.colors.pine}
      # yellow
      color3  ${theme.colors.gold}
      color11 ${theme.colors.gold}
      # blue
      color4  ${theme.colors.iris}
      color12 ${theme.colors.iris}
      # magenta
      color5  ${theme.colors.iris}
      color13 ${theme.colors.iris}
      # cyan
      color6  ${theme.colors.foam}
      color14 ${theme.colors.foam}
      # white
      color7  ${theme.colors.text}
      color15 ${theme.colors.text}
      # font
      font_family     ${theme.font.name}
      font_size       12.0
      # window
      background_opacity 0.9
    '';
    kittyConfNiri = pkgs.writeText "kitty.conf" baseConf;
    kittyConfHyprland = pkgs.writeText "kitty.conf" ''
      # colors managed at runtime by noctalia matugen
      include ~/.config/kitty/noctalia-colors.conf
      # font
      font_family     ${theme.font.name}
      font_size       12.0
      # window
      background_opacity 0.9
    '';
  in {
    packages.myKittyNiri = inputs.wrapper-modules.lib.wrapPackage {
      inherit pkgs;
      package = pkgs.kitty;
      flags."--config" = "${kittyConfNiri}";
    };
    packages.myKittyHyprland = inputs.wrapper-modules.lib.wrapPackage {
      inherit pkgs;
      package = pkgs.kitty;
      flags."--config" = "${kittyConfHyprland}";
    };
  };
}
