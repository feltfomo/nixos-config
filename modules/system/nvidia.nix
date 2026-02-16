{ config, pkgs, ... }:
{
  services.xserver.videoDrivers = [ "nvidia" ];
  
  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    nvidiaSettings = true;
  };

  boot.kernelParams = [
    "nvidia_drm.modeset=1"
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
    "nvidia.NVreg_TemporaryFilePath=/var/tmp"
    "nvme_load=YES"
    "nowatchdog"
  ];
  
  boot.kernelModules = [ "nvidia-uvm" ];


  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
}
