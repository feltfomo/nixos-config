{ inputs, self, ... }:
let
  vars = import ./../_config.nix;
in
{
  flake.nixosModules.footNiri =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.myFootNiri
      ];
    };

  flake.nixosModules.footHyprland =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.myFootHyprland
      ];
    };

  perSystem =
    { pkgs, ... }:
    let
      footConfNiri = pkgs.runCommand "foot-niri.ini" { nativeBuildInputs = [ pkgs.pkl ]; } ''
        pkl eval ${self + "/config/niri/dms/foot"}/main.pkl -o $out
      '';

      footConfHyprland = pkgs.writeText "foot.ini" ''
        # colors managed at runtime by noctalia matugen
        include=${vars.home}/.config/foot/noctalia-colors.ini

        [main]
        font=JetBrainsMono Nerd Font:size=12
      '';
    in
    {
      packages.myFootNiri = inputs.wrapper-modules.lib.wrapPackage {
        inherit pkgs;
        package = pkgs.foot;
        flags."-c" = "${footConfNiri}";
      };
      packages.myFootHyprland = inputs.wrapper-modules.lib.wrapPackage {
        inherit pkgs;
        package = pkgs.foot;
        flags."-c" = "${footConfHyprland}";
        flags."-e" = "${pkgs.nushell}/bin/nu";
      };
    };
}
