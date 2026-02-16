{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./modules/system/boot.nix
    ./modules/system/nvidia.nix
    ./modules/system/networking.nix
    ./modules/system/audio.nix
    ./modules/system/packages.nix
    ./modules/system/portals.nix
    ./modules/system/performance.nix
    ./modules/system/programs.nix
    ./modules/system/fonts.nix
    ./modules/system/overlays.nix
    ./modules/system/thunar.nix
    ./modules/system/nix-settings.nix
    ./modules/system/home-manager.nix
    ./modules/system/user.nix
    ./modules/system/sddm.nix
  ];

  # Services
  services = {
    dbus.enable = true;
    xserver.enable = false;
    flatpak.enable = true;
  };

  system.stateVersion = "25.11";
}
