{ config, ... }:
{
  xdg.configFile = {
    "kitty".source  = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dots/kitty";
    "rofi".source   = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dots/rofi";
    "hypr".source   = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dots/hypr";
    "waybar".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dots/waybar";
    "nvim".source   = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dots/nvim";
    "niri".source   = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dots/niri"
  };
}