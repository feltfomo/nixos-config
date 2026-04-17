{ inputs, self, ... }:
let
  vars = import ./../_config.nix;
in
{
  flake.nixosModules.hyprland =
    { pkgs, ... }:
    {
      programs.hyprland = {
        enable = true;
        package = pkgs.hyprland;
        portalPackage = pkgs.xdg-desktop-portal-hyprland;
      };

      environment.systemPackages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.myHyprland
      ];

      xdg.portal = {
        enable = true;
        extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
        config.hyprland = {
          default = [
            "hyprland"
            "gtk"
          ];
          "org.freedesktop.impl.portal.ScreenCast" = [ "hyprland" ];
          "org.freedesktop.impl.portal.Screenshot" = [ "hyprland" ];
        };
      };

      environment.sessionVariables = {
        LIBVA_DRIVER_NAME = "nvidia";
        GBM_BACKEND = "nvidia-drm";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        NVD_BACKEND = "direct";
      };
    };

  perSystem =
    {
      pkgs,
      lib,
      self',
      ...
    }:
    let
      pm = vars.monitors.primary;
      sm = vars.monitors.secondary;

      workspaceScript = pkgs.writeScript "hypr-workspace.nu" ''
        #!/usr/bin/env nu

        def main [num: int] {
          let monitors = (hyprctl monitors -j | from json)
          let cursor = (hyprctl cursorpos -j | from json)

          let active_monitor = ($monitors | where {|m|
            ($cursor.x >= $m.x) and ($cursor.x < ($m.x + $m.width)) and ($cursor.y >= $m.y) and ($cursor.y < ($m.y + $m.height))
          } | first)

          let workspace = if $active_monitor.name == "${sm.name}" {
            $num + 10
          } else {
            $num
          }

          hyprctl dispatch workspace $workspace
        }
      '';

      moveToWorkspaceScript = pkgs.writeScript "hypr-movetoworkspace.nu" ''
        #!/usr/bin/env nu

        def main [num: int] {
          let monitors = (hyprctl monitors -j | from json)
          let cursor = (hyprctl cursorpos -j | from json)

          let active_monitor = ($monitors | where {|m|
            ($cursor.x >= $m.x) and ($cursor.x < ($m.x + $m.width)) and ($cursor.y >= $m.y) and ($cursor.y < ($m.y + $m.height))
          } | first)

          let workspace = if $active_monitor.name == "${sm.name}" {
            $num + 10
          } else {
            $num
          }

          hyprctl dispatch movetoworkspace $workspace
        }
      '';

      submapDaemon = pkgs.writeScript "hypr-submap-daemon.nu" ''
        #!/usr/bin/env nu

        let socket = $"($env.XDG_RUNTIME_DIR)/hypr/($env.HYPRLAND_INSTANCE_SIGNATURE)/.socket2.sock"

        ^socat -U - $"UNIX-CONNECT:($socket)" | lines | each {|line|
          if ($line | str starts-with "submap>>") {
            let name = ($line | str replace "submap>>" "")
            if $name == "" {
              ^noctalia-shell ipc call plugin:submap-osd dismiss
            } else {
              $name | save --force /tmp/hypr-submap
              ^noctalia-shell ipc call plugin:submap-osd display
            }
          }
        }
      '';

      hyprlandConfPkl = pkgs.runCommand "hyprland-config-raw.conf" { nativeBuildInputs = [ pkgs.pkl ]; } ''
        pkl eval ${self + "/config/hyprland/settings"}/main.pkl -o $out
      '';

      hyprlandConf = pkgs.substitute {
        src = hyprlandConfPkl;
        substitutions = [
          "--subst-var-by" "xcursorTheme"          vars.cursor.name
          "--subst-var-by" "xcursorSize"           (toString vars.cursor.size)
          "--subst-var-by" "primaryName"           pm.name
          "--subst-var-by" "primaryRes"            pm.res
          "--subst-var-by" "primaryX"              (toString pm.x)
          "--subst-var-by" "secondaryName"         sm.name
          "--subst-var-by" "secondaryRes"          sm.res
          "--subst-var-by" "secondaryX"            (toString sm.x)
          "--subst-var-by" "noctaliaHyprlandBin"   (lib.getExe self'.packages.myNoctalia)
          "--subst-var-by" "kittyHyprlandBin"      (lib.getExe self'.packages.myKittyHyprland)
          "--subst-var-by" "firefoxBin"            (lib.getExe pkgs.firefox)
          "--subst-var-by" "windowsOpacity"        (toString vars.opacity.windows)
          "--subst-var-by" "workspaceScript"       workspaceScript
          "--subst-var-by" "moveToWorkspaceScript" moveToWorkspaceScript
          "--subst-var-by" "submapDaemon"          submapDaemon
        ];
      };
    in
    {
      packages.myHyprland = inputs.wrapper-modules.lib.wrapPackage {
        inherit pkgs;
        package = pkgs.hyprland;
        env.HYPRLAND_CONFIG = "${hyprlandConf}";
      };
    };
}
