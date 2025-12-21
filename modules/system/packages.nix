{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # System tools
    wget
    git
    vim
    
    # Nix tooling
    nixfmt-rfc-style
    nil
    
    # Polkit
    polkit_gnome
  ];
  
  nixpkgs.config.allowUnfree = true;
}