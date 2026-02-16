{ config, pkgs, ... }:

{
  programs.fastfetch = {
    enable = true;

    settings = {
      "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";

      logo.type = "auto";

      display.separator = " ";

      modules = [
        {
          type = "title";
          format = "{user-name}@{host-name}";
          color = {
            user = "magenta";
            at = "white";
            host = "magenta";
          };
        }
        {
          type = "custom";
          format = "────────────────────────────────────";
          outputColor = "white";
        }

        {
          type = "custom";
          format = "┌────────── SYSTEM ──────────────────";
          outputColor = "blue";
        }
        {
          type = "os";
          key = "│ 󰍹 OS";
          keyColor = "blue";
        }
        {
          type = "host";
          key = "│ 󰌢 Host";
          keyColor = "blue";
        }
        {
          type = "kernel";
          key = "│ 󰒔 Kernel";
          keyColor = "blue";
        }
        {
          type = "uptime";
          key = "│ 󰅐 Uptime";
          keyColor = "blue";
        }
        {
          type = "packages";
          key = "│ 󰏖 Packages";
          keyColor = "blue";
        }
        {
          type = "locale";
          key = "│ 󰌌 Locale";
          keyColor = "blue";
        }
        {
          type = "custom";
          format = "└────────────────────────────────────";
          outputColor = "blue";
        }

        {
          type = "custom";
          format = "";
        }

        {
          type = "custom";
          format = "┌────────── ENVIRONMENT ─────────────";
          outputColor = "cyan";
        }
        {
          type = "shell";
          key = "│ Shell";
          keyColor = "cyan";
        }
        {
          type = "wm";
          key = "│ 󰖲 WM";
          keyColor = "cyan";
        }
        {
          type = "terminal";
          key = "│  Terminal";
          keyColor = "cyan";
        }
        {
          type = "display";
          key = "│ 󰍹 Display";
          keyColor = "cyan";
        }
        {
          type = "custom";
          format = "└────────────────────────────────────";
          outputColor = "cyan";
        }

        {
          type = "custom";
          format = "";
        }

        {
          type = "custom";
          format = "┌────────── HARDWARE ────────────────";
          outputColor = "magenta";
        }
        {
          type = "cpu";
          key = "│ 󰻠 CPU";
          keyColor = "magenta";
          format = "{1} ({3}) @ {7} GHz";
        }
        {
          type = "gpu";
          key = "│ 󰍛 GPU";
          keyColor = "magenta";
          format = "{2} [{4}°C]";
        }
        {
          type = "disk";
          key = "│ 󰋊 Disk";
          folders = [ "/" ];
          keyColor = "magenta";
        }
        {
          type = "memory";
          key = "│ 󰍛 Memory";
          keyColor = "magenta";
        }
        {
          type = "custom";
          format = "└────────────────────────────────────";
          outputColor = "magenta";
        }

        {
          type = "custom";
          format = "";
        }
        {
          type = "colors";
          symbol = "circle";
        }
      ];
    };
  };
}
