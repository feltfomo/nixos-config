{ config, pkgs, inputs, ... }:
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

    inputs.silentSDDM.nixosModules.default
  ];

  # Locale
  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_US.UTF-8";

  # Services
  services = {
    dbus.enable = true;
    xserver.enable = false;
    flatpak.enable = true;
  };

  programs.silentSDDM = {
    enable = true;
    theme = "rei";
    profileIcons = {
      zynth = "/home/zynth/Pictures/avatar.png";
    };
  };

  # User
  users.users.zynth = {
    isNormalUser = true;
    description = "zynth";
    extraGroups = [ "networkmanager" "wheel" "video" "audio" ];
    shell = pkgs.zsh;
  };

  # Nix settings
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "25.11";
}
