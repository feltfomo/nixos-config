{ pkgs, config, inputs, ... }:
{
  imports = [
    inputs.spicetify-nix.homeManagerModules.default
    ./modules/home/zsh.nix
    ./modules/home/neovim.nix
    ./modules/home/gtk.nix
    ./modules/home/spicetify.nix
    ./modules/home/dotfiles.nix
  ];
  
  home.username = "zynth";
  home.homeDirectory = "/home/zynth";
  home.stateVersion = "25.05";
  
  home.packages = with pkgs; [
    catppuccin-gtk
    papirus-icon-theme
    bibata-cursors
    gsettings-desktop-schemas
    glib
    gnome-themes-extra
    libsForQt5.qt5ct
    qt6ct
    libsForQt5.qtstyleplugin-kvantum
    qt6Packages.qtstyleplugin-kvantum
    adwaita-qt
    adwaita-qt6
    kdePackages.qtdeclarative
    dconf-editor
    vscodium
    prismlauncher
    jetbrains.idea-community-bin
    exodus
    spicetify-cli
    discord
    ghostty
    kitty
    alacritty
    zed-editor
    xfce.thunar
    rofi-wayland
    inputs.zen-browser.packages.${pkgs.system}.default
    inputs.swww.packages.${pkgs.system}.swww
    inputs.quickshell.packages.${pkgs.system}.default
    fastfetch
    grimblast
    satty
    atuin
    direnv
    code-cursor
    gcc
    rustup
    pkg-config
    openssl
  ];
}
