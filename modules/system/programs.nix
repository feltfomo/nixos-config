{ config, pkgs, ... }:
{
  programs = {
    hyprland.enable = true;
    gamemode.enable = true;
    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        glib
        zlib
        libglvnd
        mesa
        libdrm
        wayland
      ];
    };
  };
}