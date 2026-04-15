{ inputs, self, ... }:
{
  flake.nixosModules.kittyNiri =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.myKittyNiri
      ];
    };

  flake.nixosModules.kittyHyprland =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.myKittyHyprland
      ];
    };

  perSystem =
    { pkgs, ... }:
    let
      vars = import ./../_config.nix;
      theme = import ./_theme.nix { inherit pkgs; };
      kittyConfNiri = pkgs.writeText "kitty.conf" ''
        # colors managed at runtime by DMS matugen
        include /home/${vars.username}/.config/kitty/dms-colors.conf
        # font
        font_family     ${theme.font.name}
        font_size       ${toString theme.fontSize.terminal}
        # window
        background_opacity ${toString theme.opacity.terminal}
      '';
      kittyConfHyprland = pkgs.writeText "kitty.conf" ''
        # colors managed at runtime by noctalia matugen
        include ~/.config/kitty/noctalia-colors.conf
        # font
        font_family     ${theme.font.name}
        font_size       ${toString theme.fontSize.terminal}
        # window
        background_opacity ${toString theme.opacity.terminal}
      '';
    in
    {
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
