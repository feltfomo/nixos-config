{ config, pkgs, ... }:

{
  programs = {
    firefox.enable = true;
    hyprland.enable = true;
    zsh.enable = true;
    gamemode.enable = true;
    niri.enable = true;

    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        glib
        zlib
        expat
        dbus
        nspr
        nss
        xorg.libX11
        xorg.libXext
        xorg.libXrender
        xorg.libXrandr
        xorg.libXcursor
        xorg.libXfixes
        xorg.libXi
        libxkbcommon
        xorg.libxcb
        xorg.libXcomposite
        xorg.libXdamage
        xorg.libXScrnSaver
        wayland
        libdrm
        mesa
        alsa-lib
        libpulseaudio
        libnotify
        libsecret
        libgbm
        libglvnd
        atk
        gtk3
        pango
        cairo
        gdk-pixbuf
        at-spi2-core
        cups
      ];
    };

    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
    };
  };
}