{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./packages.nix
    ./modules/system/boot.nix
    ./modules/system/nvidia.nix
    ./modules/system/fonts.nix
    ./modules/system/desktop.nix
    ./modules/system/programs.nix
  ];

  # Networking
  networking = {
    hostName = "fomonix";
    networkmanager.enable = true;
  };

  # Localization
  time.timeZone = "America/Los_Angeles";

  # System settings
  nixpkgs.config.allowUnfree = true;
  home-manager.backupFileExtension = "backup";

  # User configuration
  users = {
    users.zynth = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      packages = with pkgs; [ tree ];
    };
    defaultUserShell = pkgs.zsh;
  };

  system.stateVersion = "25.05";
}