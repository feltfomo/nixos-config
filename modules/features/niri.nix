{ inputs, self, ... }:
{
  flake.nixosModules.niri =
    { pkgs, lib, ... }:
    {
      # Wrapped niri wins in PATH over the unwrapped one registered by programs.niri.
      # Wrapped kitty is installed by kittyNiri module.
      environment.systemPackages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.myNiri
        pkgs.nautilus
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
      theme = import ./../theme/_theme.nix { inherit pkgs; };
    in
    {
      packages.myNiri = inputs.wrapper-modules.wrappers.niri.wrap {
        inherit pkgs;
        v2-settings = true;
        settings = {
          prefer-no-csd = _: { };
          xwayland-satellite.path = "${pkgs.xwayland-satellite}/bin/xwayland-satellite";

          input = {
            keyboard.xkb = {
              layout = "us";
              options = "caps:escape";
            };
            touchpad = {
              tap = _: { };
              natural-scroll = _: { };
            };
            mouse.accel-profile = "flat";
            focus-follows-mouse = _: { };
          };

          gestures."hot-corners".off = _: { };

          spawn-at-startup = [
            [ (lib.getExe self'.packages.myNoctaliaNiri) ]
          ];

          layout = {
            gaps = 16;
            always-center-single-column = _: { };
            focus-ring = {
              width = 2;
              active-color = theme.colors.love;
              inactive-color = theme.colors.overlay;
            };
            border.off = _: { };
          };

          cursor = {
            xcursor-theme = theme.cursor.name;
            xcursor-size = theme.cursor.size;
          };

          window-rules = [
            {
              geometry-corner-radius = 10;
              clip-to-geometry = true;
            }
          ];

          layer-rules = [
            {
              matches = [ { namespace = "^noctalia-overview*"; } ];
              place-within-backdrop = true;
            }
          ];

          binds = {
            # apps
            "Mod+T".spawn-sh = lib.getExe self'.packages.myKittyNiri;
            "Mod+W".spawn-sh = lib.getExe pkgs.firefox;
            "Mod+Space".spawn-sh = "${lib.getExe self'.packages.myNoctaliaNiri} ipc call launcher toggle";
            "Mod+C".spawn-sh = "${lib.getExe self'.packages.myNoctaliaNiri} ipc call clipboard toggle";

            # window management
            "Mod+Q".close-window = _: { };
            "Mod+F".maximize-column = _: { };
            "Mod+Shift+F".fullscreen-window = _: { };
            "Mod+V".toggle-window-floating = _: { };
            "Mod+grave".toggle-overview = _: { };

            # focus columns (left/right within workspace)
            "Mod+H".focus-column-left = _: { };
            "Mod+L".focus-column-right = _: { };
            "Mod+Left".focus-column-left = _: { };
            "Mod+Right".focus-column-right = _: { };

            # focus workspaces (up/down)
            "Mod+J".focus-workspace-down = _: { };
            "Mod+K".focus-workspace-up = _: { };
            "Mod+Down".focus-workspace-down = _: { };
            "Mod+Up".focus-workspace-up = _: { };

            # focus monitors
            "Mod+Alt+Left".focus-monitor-left = _: { };
            "Mod+Alt+Right".focus-monitor-right = _: { };

            # move columns within workspace
            "Mod+Shift+H".move-column-left-or-to-monitor-left = _: { };
            "Mod+Shift+L".move-column-right-or-to-monitor-right = _: { };
            "Mod+Shift+Left".move-column-left-or-to-monitor-left = _: { };
            "Mod+Shift+Right".move-column-right-or-to-monitor-right = _: { };

            # move windows between workspaces
            "Mod+Shift+J".move-window-to-workspace-down = _: { };
            "Mod+Shift+K".move-window-to-workspace-up = _: { };
            "Mod+Shift+Down".move-window-to-workspace-down = _: { };
            "Mod+Shift+Up".move-window-to-workspace-up = _: { };

            # move windows to other monitor
            "Mod+Shift+Alt+Left".move-window-to-monitor-left = _: { };
            "Mod+Shift+Alt+Right".move-window-to-monitor-right = _: { };

            # consume/expel windows into/from columns
            "Mod+I".consume-window-into-column = _: { };
            "Mod+O".expel-window-from-column = _: { };

            # focus vertical windows
            "Mod+Shift+I".focus-window-up = _: { };
            "Mod+Shift+O".focus-window-down = _: { };

            # resize
            "Mod+Ctrl+Left".set-column-width = "-5%";
            "Mod+Ctrl+Right".set-column-width = "+5%";
            "Mod+Ctrl+Up".set-window-height = "+5%";
            "Mod+Ctrl+Down".set-window-height = "-5%";

            # system
            "Mod+Shift+E".quit = _: { };
            "Mod+Shift+P".power-off-monitors = _: { };
            "Print".screenshot = _: { };
            "Ctrl+Print".screenshot-screen = _: { };
            "Alt+Print".screenshot-window = _: { };

            # audio
            "XF86AudioRaiseVolume".spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
            "XF86AudioLowerVolume".spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
            "XF86AudioMute".spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          };
        };
      };
    };
}
