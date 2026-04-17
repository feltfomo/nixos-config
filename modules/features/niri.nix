{ inputs, self, ... }:
{
  flake.nixosModules.niri =
    { pkgs, lib, ... }:
    {
      # Enables portals, polkit integration, and registers a wayland session.
      programs.niri.enable = true;

      environment.systemPackages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.myNiri
        pkgs.nautilus
      ];

      services.displayManager.sessionPackages = [
        (pkgs.runCommand "niri-session-desktop"
          {
            passthru.providedSessions = [ "niri" ];
          }
          ''
            mkdir -p $out/share/wayland-sessions
            cat > $out/share/wayland-sessions/niri.desktop <<EOF
            [Desktop Entry]
            Name=Niri
            Comment=A scrollable-tiling Wayland compositor
            Exec=${self.packages.${pkgs.stdenv.hostPlatform.system}.myNiri}/bin/niri --session
            Type=Application
            DesktopNames=niri
            EOF
          ''
        )
      ];

      xdg.portal = {
        enable = true;
        extraPortals = lib.mkForce [
          pkgs.xdg-desktop-portal-gtk
          pkgs.xdg-desktop-portal-gnome
        ];
        config.niri = {
          default = [
            "gnome"
            "gtk"
          ];
          "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
          "org.freedesktop.impl.portal.Screenshot" = [ "gnome" ];
        };
      };

      # nautilus dbus integration for file picker portal
      services.dbus.packages = [ pkgs.nautilus ];
    };

  perSystem =
    {
      pkgs,
      lib,
      self',
      ...
    }:
    let
      vars = import ./../_config.nix;

      dmsBin = "${inputs.dms.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/dms";

      niriConfPkl = pkgs.runCommand "niri-config-raw.kdl" { nativeBuildInputs = [ pkgs.pkl ]; } ''
        pkl eval ${self + "/config/niri/settings"}/main.pkl -o $out
      '';

      niriConf = pkgs.replaceVars niriConfPkl {
        xwaylandBin = "${pkgs.xwayland-satellite}/bin/xwayland-satellite";
        dmsBin = dmsBin;
        kittyBin = lib.getExe self'.packages.myKittyNiri;
        firefoxBin = lib.getExe pkgs.firefox;
      };
    in
    {
      packages.myDms = inputs.dms.packages.${pkgs.stdenv.hostPlatform.system}.default;

      packages.myNiri = inputs.wrapper-modules.lib.wrapPackage {
        inherit pkgs;
        package = inputs.niri.packages.${pkgs.stdenv.hostPlatform.system}.niri;
        env.NIRI_CONFIG = "${niriConf}";
      };
    };
}
