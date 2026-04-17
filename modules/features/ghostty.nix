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
        ".config-niri/ghostty/config".text = ''
          font-family = JetBrains Mono
          font-size = 13
          background-opacity = 0.9
          config-file = ${vars.home}/.config/ghostty/noctalia-colors
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
        ".config-hyprland/ghostty/config".text = ''
          font-family = JetBrains Mono
          font-size = 13
          background-opacity = 0.9
          config-file = ${vars.home}/.config/ghostty/noctalia-colors
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
