{ config, pkgs, ... }:
{
  services = {
    dbus.enable = true;
    tumbler.enable = true;
  };
  
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    wlr.enable = true;
    
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
    ];
    
    config = {
      common = {
        default = [ "gtk" ];
      };
    };
  };
  
  programs.dconf.enable = true;
}