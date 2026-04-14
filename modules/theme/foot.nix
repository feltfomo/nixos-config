{ inputs, self, ... }:
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
      theme = import ./_theme.nix { inherit pkgs; };
      baseConf = ''
        [main]
        font=${theme.font.name}:size=12

        [colors]
        foreground=${builtins.substring 1 6 theme.colors.text}
        background=${builtins.substring 1 6 theme.colors.base}
        selection-foreground=${builtins.substring 1 6 theme.colors.text}
        selection-background=${builtins.substring 1 6 theme.colors.overlay}

        regular0=${builtins.substring 1 6 theme.colors.overlay}
        regular1=${builtins.substring 1 6 theme.colors.love}
        regular2=${builtins.substring 1 6 theme.colors.pine}
        regular3=${builtins.substring 1 6 theme.colors.gold}
        regular4=${builtins.substring 1 6 theme.colors.iris}
        regular5=${builtins.substring 1 6 theme.colors.iris}
        regular6=${builtins.substring 1 6 theme.colors.foam}
        regular7=${builtins.substring 1 6 theme.colors.text}

        bright0=${builtins.substring 1 6 theme.colors.muted}
        bright1=${builtins.substring 1 6 theme.colors.love}
        bright2=${builtins.substring 1 6 theme.colors.pine}
        bright3=${builtins.substring 1 6 theme.colors.gold}
        bright4=${builtins.substring 1 6 theme.colors.iris}
        bright5=${builtins.substring 1 6 theme.colors.iris}
        bright6=${builtins.substring 1 6 theme.colors.foam}
        bright7=${builtins.substring 1 6 theme.colors.text}
      '';
      footConfNiri = pkgs.writeText "foot.ini" baseConf;
      footConfHyprland = pkgs.writeText "foot.ini" ''
        # colors managed at runtime by noctalia matugen
        include=/home/feltfomo/.config/foot/noctalia-colors.ini

        [main]
        font=${theme.font.name}:size=12
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
