{ config, pkgs, ... }:
{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    extraConfig = {
      modi = "drun,run";
      show-icons = true;
      display-drun = " Apps";
      display-run = " Run";
      drun-display-format = "{name}";
      drun-match-fields = "name,generic,exec,categories,keywords";
    };
    theme =
      let
        inherit (config.lib.formats.rasi) mkLiteral;
      in
      {
        "*" = {
          bg-col = mkLiteral "#1e1e2e";
          bg-col-light = mkLiteral "#313244";
          border-col = mkLiteral "#cba6f7";
          selected-col = mkLiteral "#45475a";
          blue = mkLiteral "#89b4fa";
          fg-col = mkLiteral "#cdd6f4";
          fg-col2 = mkLiteral "#f38ba8";
          grey = mkLiteral "#6c7086";
          mauve = mkLiteral "#cba6f7";
          lavender = mkLiteral "#b4befe";
          width = 700;
          font = "JetBrains Mono 12";
        };
        "element-text, element-icon, mode-switcher" = {
          background-color = mkLiteral "inherit";
          text-color = mkLiteral "inherit";
        };
        "window" = {
          height = mkLiteral "500px";
          border = mkLiteral "2px";
          border-color = mkLiteral "@mauve";
          background-color = mkLiteral "@bg-col";
          border-radius = mkLiteral "10px";
        };
        "mainbox" = {
          background-color = mkLiteral "@bg-col";
        };
        "inputbar" = {
          children = mkLiteral "[prompt,entry]";
          background-color = mkLiteral "@bg-col";
          border-radius = mkLiteral "5px";
          padding = mkLiteral "12px";
          margin = mkLiteral "12px";
        };
        "prompt" = {
          background-color = mkLiteral "@mauve";
          padding = mkLiteral "12px";
          text-color = mkLiteral "@bg-col";
          border-radius = mkLiteral "5px";
          margin = mkLiteral "0px 12px 0px 0px";
        };
        "entry" = {
          padding = mkLiteral "12px";
          background-color = mkLiteral "@bg-col-light";
          text-color = mkLiteral "@fg-col";
          border-radius = mkLiteral "5px";
        };
        "listview" = {
          border = mkLiteral "0px";
          padding = mkLiteral "12px";
          margin = mkLiteral "12px";
          columns = 1;
          lines = 8;
          background-color = mkLiteral "@bg-col";
          spacing = mkLiteral "8px";
        };
        "element" = {
          padding = mkLiteral "12px";
          background-color = mkLiteral "@bg-col";
          text-color = mkLiteral "@fg-col";
          border-radius = mkLiteral "5px";
          orientation = mkLiteral "horizontal";
          children = mkLiteral "[element-icon, element-text]";
          spacing = mkLiteral "12px";
        };
        "element-icon" = {
          size = mkLiteral "32px";
          vertical-align = mkLiteral "0.5";
        };
        "element-text" = {
          vertical-align = mkLiteral "0.5";
          text-color = mkLiteral "@fg-col";
        };
        "element selected" = {
          background-color = mkLiteral "@selected-col";
          text-color = mkLiteral "@lavender";
          border = mkLiteral "2px";
          border-color = mkLiteral "@mauve";
        };
        "mode-switcher" = {
          spacing = 0;
        };
        "button" = {
          padding = mkLiteral "10px";
          background-color = mkLiteral "@bg-col-light";
          text-color = mkLiteral "@grey";
          vertical-align = mkLiteral "0.5";
          horizontal-align = mkLiteral "0.5";
        };
        "button selected" = {
          background-color = mkLiteral "@bg-col";
          text-color = mkLiteral "@blue";
        };
      };
  };
}
