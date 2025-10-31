{ pkgs, config, ... }:

{
  home.username = "zynth";
  home.homeDirectory = "/home/zynth";
  home.stateVersion = "25.05";

  xdg.configFile."kitty".source  = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dots/kitty";
  xdg.configFile."rofi".source  = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dots/rofi";

  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-Mocha-Standard-Blue-Dark";
      package = pkgs.catppuccin-gtk;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    cursorTheme = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
    };
  };
}
