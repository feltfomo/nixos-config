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
      kittyStaticConf = pkgs.runCommand "kitty-static.conf" { nativeBuildInputs = [ pkgs.pkl ]; } ''
        pkl eval ${self + "/config/niri/dms/kitty"}/main.pkl -o $out 
      '';
      kittyConfNiri = pkgs.writeText "kitty.conf" ''
        include /home/${vars.username}/.config/kitty/dms-colors.conf
        include ${kittyStaticConf}
      '';
      kittyConfHyprland = pkgs.writeText "kitty.conf" ''
        include ~/.config/kitty/noctalia-colors.conf
        include ${kittyStaticConf}
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
