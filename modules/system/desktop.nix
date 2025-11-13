{ config, pkgs, ... }:

{
  services = {
    dbus.enable = true;
    tumbler.enable = true;
  };

  systemd.user.services = {
    xdg-desktop-portal-gtk = {
      environment.WAYLAND_DISPLAY = "wayland-1";
      serviceConfig = {
        Restart = "on-failure";
        RestartSec = "1s";
      };
    };

    xdg-desktop-portal = {
      environment.WAYLAND_DISPLAY = "wayland-1";
      serviceConfig = {
        Restart = "on-failure";
        RestartSec = "1s";
      };
    };
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    wlr.enable = true;
    
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr
      xdg-desktop-portal-hyprland
    ];
    
    config = {
      common = {
        default = [ "gtk" ];
        "org.freedesktop.impl.portal.Settings" = [ "gtk" ];
      };
      niri = {
        default = [ "wlr" "gtk" ];
      };
    };
  };

  programs.dconf.enable = true;
}