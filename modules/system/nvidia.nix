{ config, pkgs, ... }:
{
  services.xserver.videoDrivers = [ "nvidia" ];
  
  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    nvidiaSettings = true;
    powerManagement.enable = true;
    package = config.boot.kernelPackages.nvidiaPackages.production;
  };
  
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
}