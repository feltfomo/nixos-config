{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./modules/system/boot.nix
    ./modules/system/nvidia.nix
    ./modules/system/networking.nix
    ./modules/system/audio.nix
    ./modules/system/hyprland.nix
    ./modules/system/packages.nix
    ./modules/system/portals.nix
    ./modules/system/performance.nix
    ./modules/system/programs.nix
  ];

  # Timezone & Locale
  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_US.UTF-8";

  # User account
  users.users.zynth = {
    isNormalUser = true;
    description = "zynth";
    extraGroups = [ "networkmanager" "wheel" "video" "audio" ];
    packages = with pkgs; [ ];
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "25.11";
}
