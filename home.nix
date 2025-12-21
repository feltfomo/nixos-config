{  config, pkgs, inputs, ...}:
{
  imports = [
    ./modules/home/gtk.nix
    inputs.noctalia-shell.homeModules.default
  ];

  home.username = "zynth";
  home.homeDirectory = "/home/zynth";
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;

  # Enable noctalia shell
  programs.noctalia-shell.enable = true;

  qt = {
    enable = true;
    platformTheme.name = "adwaita";
    style.name = "adwaita-dark";
  };

  home.sessionVariables = {
    LD_LIBRARY_PATH = "/run/opengl-driver/lib:$LD_LIBRARY_PATH";
  };

  home.packages = with pkgs; [
    # Editors
    neovim
    zed-editor
    vscodium

    # Terminal
    ghostty

    # Browser
    firefox

    # File Manager
    xfce.thunar
    yazi
    nautilus
    kdePackages.dolphin

    # Themes
    catppuccin-gtk
    papirus-icon-theme
    bibata-cursors

    # Quickshell
    inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default

    # Wallpaper & music
    swww
    spotify

    # Minecraft
    prismlauncher

    # ffmpeg
    ffmpeg

    # Theme
    adwaita-qt
    adwaita-qt6

    # Useless
    fastfetch

    # Java dev
    jetbrains.idea-community
    jdk21
    gradle

    satty
    grimblast
    slurp
    grim
    
    appimage-run

    ayugram-desktop

  ];
}
