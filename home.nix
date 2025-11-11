{ pkgs, config, inputs, ... }:
{
  imports = [
    inputs.spicetify-nix.homeManagerModules.default
    ./modules/zsh.nix
    ./modules/neovim.nix
    ./modules/gtk.nix
    ./modules/spicetify.nix
  ];
  
  home.username = "zynth";
  home.homeDirectory = "/home/zynth";
  home.stateVersion = "25.05";
  
  home.packages = with pkgs; [
    catppuccin-gtk
    papirus-icon-theme
    bibata-cursors
    qt6ct
    fastfetch
  ];
}