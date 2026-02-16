{ config, pkgs, ... }:
{
  programs.zed-editor = {
    enable = true;
    mutableUserSettings = false;
    userSettings = {
      icon_theme = "Catppuccin Mocha";
      ui_font_size = 16;
      buffer_font_size = 15;
      buffer_font_family = "JetBrains Mono";
      theme = {
        mode = "system";
        light = "One Light";
        dark = "Catppuccin Mocha";
      };
      autosave = "on_focus_change";
      format_on_save = "on";
      tab_size = 2;
      soft_wrap = "editor_width";
      inlay_hints = {
        enabled = true;
      };
      session = {
        trust_all_worktrees = true;
      };
    };
  };

  home.packages = [
    (pkgs.writeShellScriptBin "zed" ''
      WAYLAND_DISPLAY="" exec ${config.programs.zed-editor.package}/bin/zeditor "$@"
    '')
  ];
}
