{ config, pkgs, ... }:
{
  programs.zed-editor = {
    enable = true;
    userSettings = {
      icon_theme = "Catppuccin Mocha";
      ui_font_size = 16;
      buffer_font_size = 15;
      theme = {
        mode = "system";
        light = "One Light";
        dark = "Catppuccin Mocha";
      };
    };
  };
}
