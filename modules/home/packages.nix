{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    # Modern CLI replacements
    ripgrep
    fd
    dust
    duf

    # Editors
    vscodium

    # Terminal
    microfetch

    # Browsers
    firefox
    floorp-bin

    # File managers
    yazi
    nautilus
    kdePackages.dolphin

    # Media
    ffmpeg

    # Screenshots
    satty
    grimblast
    slurp
    grim

    # Clipboard
    cliphist
    wl-clipboard

    # Gaming
    lunar-client
    steam
    steam-run
    protonplus

    # Java dev
    jetbrains.idea-oss
    nix-direnv
    (pkgs.writeShellScriptBin "idea" ''
      exec nix-shell --expr 'import /etc/nixos/modules/dev/java.nix { pkgs = import <nixpkgs> {}; }' \
        --run "DISPLAY=:0 WAYLAND_DISPLAY=wayland-1 GDK_BACKEND=wayland QT_QPA_PLATFORM=wayland _JAVA_AWT_WM_NONREPARENTING=1 idea-oss $@"
    '')

    # Note Taking
    obsidian

    # Misc
    appimage-run
    ayugram-desktop
    desktop-file-utils
    xwayland-satellite

    # Qt theming
    libsForQt5.qtstyleplugin-kvantum
    kdePackages.qtstyleplugin-kvantum
    catppuccin-kvantum
    qt6Packages.qt6ct
    jq
    icu
    socat
  ];
}
