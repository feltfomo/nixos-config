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
      theme = import ./../theme/_theme.nix { inherit pkgs; };

      niriConf = pkgs.writeText "niri-config.kdl" ''
        prefer-no-csd

        xwayland-satellite {
          path "${pkgs.xwayland-satellite}/bin/xwayland-satellite"
        }

        environment {
          XDG_CURRENT_DESKTOP "niri"
          ELECTRON_OZONE_PLATFORM_HINT "auto"
        }

        input {
          keyboard {
            xkb {
              layout "us"
              options "caps:escape"
            }
          }
          touchpad {
            tap
            natural-scroll
          }
          mouse {
            accel-profile "flat"
          }
          focus-follows-mouse
          warp-mouse-to-focus
        }

        gestures {
          hot-corners {
            off
          }
        }

        cursor {
          xcursor-theme "${theme.cursor.name}"
          xcursor-size ${toString theme.cursor.size}
        }

        layout {
          gaps 8
          background-color "transparent"
          always-center-single-column

          focus-ring {
            off
          }

          border {
            width 2
            active-color "${theme.colors.love}"
            inactive-color "${theme.colors.overlay}"
          }

          blur {
            passes 4
            radius 3
            noise 0.02
          }
        }

        window-rule {
          geometry-corner-radius 12
          clip-to-geometry true
        }

        window-rule {
          match app-id=r#"^org\.gnome\."#
          draw-border-with-background false
          geometry-corner-radius 12
          clip-to-geometry true
        }

        window-rule {
          match app-id="com.mitchellh.ghostty"
          match app-id="kitty"
          match app-id="foot"
          match app-id="brave-browser"
          match app-id="zen-twilight"
          draw-border-with-background false
        }
        window-rule {
          opacity 0.9
        }

        // Float quickshell/DMS windows
        window-rule {
          match app-id=r#"org\.quickshell$"#
          open-floating true
        }

        // Blur all windows
        window-rule {
          blur {
            on
            x-ray true
          }
        }

        layer-rule {
          match namespace="^dms:.*$"
          blur {
            on
            x-ray false
            ignore-alpha 0.45
          }
        }

        // DMS layer rules
        layer-rule {
          match namespace="^quickshell$"
          place-within-backdrop true
        }

        // Blur wallpaper layer (DMS blur branch)
        layer-rule {
          match namespace="dms:blurwallpaper"
          place-within-backdrop true
        }

        // colors managed at runtime by DMS matugen — overrides static border above
        include "${vars.home}/.config/niri/dms-colors.kdl"

        spawn-at-startup "${dmsBin}" "run"

        binds {
          // DMS
          Mod+Space hotkey-overlay-title="Application Launcher" {
            spawn "dms" "ipc" "call" "spotlight" "toggle";
          }
          Mod+C hotkey-overlay-title="Clipboard Manager" {
            spawn "dms" "ipc" "call" "clipboard" "toggle";
          }
          Mod+N hotkey-overlay-title="Notification Center" {
            spawn "dms" "ipc" "call" "notifications" "toggle";
          }
          Mod+Comma hotkey-overlay-title="Settings" {
            spawn "dms" "ipc" "call" "settings" "focusOrToggle";
          }
          Mod+Y hotkey-overlay-title="Browse Wallpapers" {
            spawn "dms" "ipc" "call" "dankdash" "wallpaper";
          }
          Mod+Alt+L hotkey-overlay-title="Lock Screen" {
            spawn "dms" "ipc" "call" "lock" "lock";
          }

          // Apps
          Mod+T { spawn "${lib.getExe self'.packages.myKittyNiri}"; }
          Mod+W { spawn "${lib.getExe pkgs.firefox}"; }

          // Window management
          Mod+Q { close-window; }
          Mod+F { maximize-column; }
          Mod+Shift+F { fullscreen-window; }
          Mod+V { toggle-window-floating; }
          Mod+grave { toggle-overview; }

          // Focus columns
          Mod+H { focus-column-left; }
          Mod+L { focus-column-right; }
          Mod+Left { focus-column-left; }
          Mod+Right { focus-column-right; }

          // Focus windows within column
          Mod+J { focus-window-down; }
          Mod+K { focus-window-up; }
          Mod+Down { focus-window-down; }
          Mod+Up { focus-window-up; }

          // Focus workspaces
          Mod+Shift+J { focus-workspace-down; }
          Mod+Shift+K { focus-workspace-up; }
          Mod+Shift+Down { focus-workspace-down; }
          Mod+Shift+Up { focus-workspace-up; }

          // Focus monitors
          Mod+Alt+Left { focus-monitor-left; }
          Mod+Alt+Right { focus-monitor-right; }

          // Move columns
          Mod+Ctrl+H { move-column-left-or-to-monitor-left; }
          Mod+Ctrl+L { move-column-right-or-to-monitor-right; }
          Mod+Ctrl+Left { move-column-left-or-to-monitor-left; }
          Mod+Ctrl+Right { move-column-right-or-to-monitor-right; }

          // Move windows to workspaces
          Mod+Ctrl+J { move-window-to-workspace-down; }
          Mod+Ctrl+K { move-window-to-workspace-up; }
          Mod+Ctrl+Down { move-window-to-workspace-down; }
          Mod+Ctrl+Up { move-window-to-workspace-up; }

          // Move to monitors
          Mod+Shift+Alt+Left { move-window-to-monitor-left; }
          Mod+Shift+Alt+Right { move-window-to-monitor-right; }

          // Consume/expel
          Mod+BracketLeft { consume-window-into-column; }
          Mod+BracketRight { expel-window-from-column; }

          // Resize
          Mod+Shift+H { set-column-width "-5%"; }
          Mod+Shift+L { set-column-width "+5%"; }
          Mod+Shift+Left { set-column-width "-5%"; }
          Mod+Shift+Right { set-column-width "+5%"; }
          Mod+Ctrl+Shift+Up { set-window-height "+5%"; }
          Mod+Ctrl+Shift+Down { set-window-height "-5%"; }
          
          // System
          Mod+Shift+E { quit; }
          Mod+Shift+P { power-off-monitors; }
          Print { screenshot; }
          Ctrl+Print { screenshot-screen; }
          Alt+Print { screenshot-window; }

          // Volume
          Mod+Equal allow-when-locked=true {
            spawn "dms" "ipc" "call" "audio" "increment" "3";
          }
          Mod+Minus allow-when-locked=true {
            spawn "dms" "ipc" "call" "audio" "decrement" "3";
          }
          Mod+Shift+M allow-when-locked=true {
            spawn "dms" "ipc" "call" "audio" "mute";
          }
        }      
      '';
      dmsBin = "${inputs.dms.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/dms";
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
