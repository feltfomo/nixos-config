{ pkgs, inputs, ... }:

{
  environment.systemPackages = with pkgs; [
    vim
    wget
    ffmpeg
    grimblast
    wl-clipboard
    prismlauncher
    spotify
    spicetify-cli
    equibop
    ghostty
    zed-editor
    btop
    fastfetch
    neovim
    xfce.thunar
    git
    rofi-wayland
    waybar
    gsettings-desktop-schemas
    glib
    dconf-editor
    gnome-themes-extra
    libsForQt5.qt5ct
    qt6ct
    libsForQt5.qtstyleplugin-kvantum
    qt6Packages.qtstyleplugin-kvantum
    adwaita-qt
    adwaita-qt6
    inputs.zen-browser.packages.${pkgs.system}.default
    inputs.swww.packages.${pkgs.system}.swww
  ];
}
