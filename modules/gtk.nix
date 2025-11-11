{ pkgs, config, ... }:
{
  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-Mocha-Standard-Blue-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "blue" ];
        size = "standard";
        variant = "mocha";
      };
    };
    iconTheme = { 
      name = "Papirus-Dark"; 
      package = pkgs.papirus-icon-theme; 
    };
    cursorTheme = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
    };
    gtk3.extraConfig = { gtk-application-prefer-dark-theme = 1; };
    gtk4.extraConfig = { gtk-application-prefer-dark-theme = 1; };
  };
  
  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };
  
  qt = {
    enable = true;
    platformTheme.name = "kvantum";
    style = {
      name = "kvantum";
      package = pkgs.qt6Packages.qtstyleplugin-kvantum;
    };
  };
  
  dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
  
  xdg.configFile = {
    "gtk-4.0/assets".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/assets";
    "gtk-4.0/gtk.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk.css";
    "gtk-4.0/gtk-dark.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk-dark.css";
    "kitty".source  = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dots/kitty";
    "rofi".source   = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dots/rofi";
    "hypr".source   = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dots/hypr";
    "waybar".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dots/waybar";
    "nvim".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dots/nvim";
  };
}