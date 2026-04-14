{ inputs, self, ... }:
{
  flake.nixosModules.hyprland =
    { pkgs, ... }:
    {
      # Keep unwrapped hyprland for SDDM session registration (passthru.providedSessions).
      # The wrapped variant is installed alongside it — it wins in PATH by being listed last.
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

      # Nvidia-specific env vars for hyprland — these live here rather than
      # desktopCommon because niri handles them differently via the wrapper.
      environment.sessionVariables = {
        LIBVA_DRIVER_NAME = "nvidia";
        GBM_BACKEND = "nvidia-drm";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        NVD_BACKEND = "direct";
      };

      # Wrapped kitty is installed by kittyHyprland module.
      # No bare pkgs.kitty here — the wrapper wins by design.
    };

  perSystem =
    {
      pkgs,
      lib,
      self',
      ...
    }:
    let
      workspaceScript = pkgs.writeScript "hypr-workspace.nu" ''
        #!/usr/bin/env nu

        def main [num: int] {
          let monitors = (hyprctl monitors -j | from json)
          let cursor = (hyprctl cursorpos -j | from json)

          let active_monitor = ($monitors | where {|m|
            ($cursor.x >= $m.x) and ($cursor.x < ($m.x + $m.width)) and ($cursor.y >= $m.y) and ($cursor.y < ($m.y + $m.height))
          } | first)

          let workspace = if $active_monitor.name == "DP-2" {
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

          let workspace = if $active_monitor.name == "DP-2" {
            $num + 10
          } else {
            $num
          }

          hyprctl dispatch movetoworkspace $workspace
        }
      '';

      submapDaemon = pkgs.writeScript "hypr-submap-daemon.nu" ''
        #!/usr/bin/env nu

        let socket = $"/run/user/1000/hypr/($env.HYPRLAND_INSTANCE_SIGNATURE)/.socket2.sock"

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

      hyprlandConf = pkgs.writeText "hyprland.conf" ''
        # nvidia (vars also set via sessionVariables but hyprland reads its own env block)
        env = LIBVA_DRIVER_NAME,nvidia
        env = GBM_BACKEND,nvidia-drm
        env = __GLX_VENDOR_LIBRARY_NAME,nvidia
        env = NVD_BACKEND,direct

        # wayland (inherited from desktopCommon sessionVariables but explicit here for hyprland)
        env = GDK_BACKEND,wayland,x11,*
        env = QT_QPA_PLATFORM,wayland;xcb
        env = SDL_VIDEODRIVER,wayland
        env = MOZ_ENABLE_WAYLAND,1
        env = ELECTRON_OZONE_PLATFORM_HINT,auto

        # cursor
        env = XCURSOR_THEME,BreezeX-RosePine-Linux
        env = XCURSOR_SIZE,24

        monitor = DP-1,2560x1440@180,0x0,1
        monitor = DP-2,2560x1440@180,2560x0,1

        exec-once = ${lib.getExe self'.packages.myNoctaliaHyprland}
        exec-once = nu ${submapDaemon}
        exec-once = wl-paste --type text --watch cliphist store
        exec-once = wl-paste --type image --watch cliphist store

        windowrule = float on, center on, match:class com.gabm.satty

        # colors managed at runtime by noctalia matugen
        source = ~/.config/hypr/noctalia-colors.conf

        general {
          gaps_in = 8
          gaps_out = 16
          border_size = 2
          col.active_border = $active_border
          col.inactive_border = $inactive_border
          layout = dwindle
        }

        decoration {
          active_opacity = 0.9
          inactive_opacity = 0.9
          rounding = 10
          blur {
            enabled = true
            size = 7
            passes = 4
          }
        }

        input {
          kb_layout = us
          kb_options = caps:escape
          accel_profile = flat
          follow_mouse = 1
          touchpad {
            natural_scroll = true
            tap-to-click = true
          }
        }

        layerrule {
          name = noctalia
          match:namespace = noctalia-background-.*$
          ignore_alpha = 0.5
          blur = true
          blur_popups = true
        }

        layerrule {
          name = submap-osd
          match:namespace = submap-osd
          blur = true
          ignore_alpha = 0.1
        }

        misc {
          disable_hyprland_logo = true
          disable_splash_rendering = true
        }

        # workspace assignments — DP-1 owns 1-10, DP-2 owns 11-20
        workspace = 1, monitor:DP-1
        workspace = 2, monitor:DP-1
        workspace = 3, monitor:DP-1
        workspace = 4, monitor:DP-1
        workspace = 5, monitor:DP-1
        workspace = 6, monitor:DP-1
        workspace = 7, monitor:DP-1
        workspace = 8, monitor:DP-1
        workspace = 9, monitor:DP-1
        workspace = 10, monitor:DP-1
        workspace = 11, monitor:DP-2
        workspace = 12, monitor:DP-2
        workspace = 13, monitor:DP-2
        workspace = 14, monitor:DP-2
        workspace = 15, monitor:DP-2
        workspace = 16, monitor:DP-2
        workspace = 17, monitor:DP-2
        workspace = 18, monitor:DP-2
        workspace = 19, monitor:DP-2
        workspace = 20, monitor:DP-2

        # apps
        bind = SUPER, T, exec, ${lib.getExe self'.packages.myKittyHyprland}
        bind = SUPER, W, exec, ${lib.getExe pkgs.firefox}
        bind = SUPER, SPACE, exec, ${lib.getExe self'.packages.myNoctaliaHyprland} ipc call launcher toggle
        bind = SUPER, C, exec, ${lib.getExe self'.packages.myNoctaliaHyprland} ipc call plugin:clipper toggle

        # window management
        bind = SUPER, Q, killactive
        bind = SUPER, F, fullscreen, 1
        bind = SUPER SHIFT, F, fullscreen, 0
        bind = SUPER, V, togglefloating

        # mouse — drag and resize
        bindm = SUPER, mouse:272, movewindow
        bindm = SUPER, mouse:273, resizewindow

        # focus
        bind = SUPER, left, movefocus, l
        bind = SUPER, right, movefocus, r
        bind = SUPER, up, movefocus, u
        bind = SUPER, down, movefocus, d

        # move windows on monitor
        bind = SUPER SHIFT, left, movewindow, l
        bind = SUPER SHIFT, right, movewindow, r
        bind = SUPER SHIFT, up, movewindow, u
        bind = SUPER SHIFT, down, movewindow, d

        # move windows between monitors
        bind = SUPER ALT, left, movewindow, mon:l
        bind = SUPER ALT, right, movewindow, mon:r

        # workspaces — script maps 1-10 to correct monitor range based on cursor position
        bind = SUPER, 1, exec, nu ${workspaceScript} 1
        bind = SUPER, 2, exec, nu ${workspaceScript} 2
        bind = SUPER, 3, exec, nu ${workspaceScript} 3
        bind = SUPER, 4, exec, nu ${workspaceScript} 4
        bind = SUPER, 5, exec, nu ${workspaceScript} 5
        bind = SUPER, 6, exec, nu ${workspaceScript} 6
        bind = SUPER, 7, exec, nu ${workspaceScript} 7
        bind = SUPER, 8, exec, nu ${workspaceScript} 8
        bind = SUPER, 9, exec, nu ${workspaceScript} 9
        bind = SUPER, 0, exec, nu ${workspaceScript} 10

        # move window to workspace — same monitor-aware logic
        bind = SUPER SHIFT, 1, exec, nu ${moveToWorkspaceScript} 1
        bind = SUPER SHIFT, 2, exec, nu ${moveToWorkspaceScript} 2
        bind = SUPER SHIFT, 3, exec, nu ${moveToWorkspaceScript} 3
        bind = SUPER SHIFT, 4, exec, nu ${moveToWorkspaceScript} 4
        bind = SUPER SHIFT, 5, exec, nu ${moveToWorkspaceScript} 5
        bind = SUPER SHIFT, 6, exec, nu ${moveToWorkspaceScript} 6
        bind = SUPER SHIFT, 7, exec, nu ${moveToWorkspaceScript} 7
        bind = SUPER SHIFT, 8, exec, nu ${moveToWorkspaceScript} 8
        bind = SUPER SHIFT, 9, exec, nu ${moveToWorkspaceScript} 9
        bind = SUPER SHIFT, 0, exec, nu ${moveToWorkspaceScript} 10

        # resize submap — SUPER+R to enter, ESC or SUPER+R to exit
        bind = SUPER, R, submap, resize
        submap = resize
        binde = , right, resizeactive, 50 0
        binde = , left, resizeactive, -50 0
        binde = , up, resizeactive, 0 -50
        binde = , down, resizeactive, 0 50
        bind = , escape, submap, reset
        bind = SUPER, R, submap, reset
        submap = reset

        # system
        bind = SUPER SHIFT, E, exit
        bind = , Print, exec, hyprshot -m output
        bind = CTRL, Print, exec, hyprshot -m region

        # audio
        bind = , XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
        bind = , XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
        bind = , XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle

        # screenshot
        bind = SUPER SHIFT, S, exec, grimblast save area /tmp/satty-screenshot.png && satty --filename /tmp/satty-screenshot.png

      '';
    in
    {
      packages.myHyprland = inputs.wrapper-modules.lib.wrapPackage {
        inherit pkgs;
        package = pkgs.hyprland;
        env.HYPRLAND_CONFIG = "${hyprlandConf}";
      };
    };
}
