{ inputs, self, ... }:
let
  commonModules = [
    inputs.lix-module.nixosModules.default
    self.nixosModules.fomonixHardware
    self.nixosModules.fomonixSystem
    self.nixosModules.disko
    self.nixosModules.impermanence
    self.nixosModules.nvidia
    self.nixosModules.desktopCommon
    self.nixosModules.orchestrator
    self.nixosModules.zed
    self.nixosModules.fonts
    self.nixosModules.cursor
    self.nixosModules.gtk
    self.nixosModules.qt
    self.nixosModules.equibop
    self.nixosModules.terminal
    self.nixosModules.spicetify
    self.nixosModules.helix
    self.nixosModules.nixvim
    self.nixosModules.zen
    self.nixosModules.brave
    self.nixosModules.packages
    self.nixosModules.minecraft
    self.nixosModules.mcsr
    self.nixosModules.prism
    self.nixosModules.obsidian
    self.nixosModules.obs
    inputs.hjem.nixosModules.default
    inputs.disko.nixosModules.disko
    inputs.impermanence.nixosModules.impermanence
    inputs.sops-nix.nixosModules.sops # wired in, not yet configured — ready for later
    inputs.silentSDDM.nixosModules.default
    inputs.nixvim.nixosModules.nixvim
  ];
in
{
  flake.nixosModules.fomonixHardware =
    {
      config,
      lib,
      modulesPath,
      ...
    }:
    {
      imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
      boot.initrd.availableKernelModules = [
        "nvme"
        "xhci_pci"
        "ahci"
        "usb_storage"
        "usbhid"
        "sd_mod"
      ];
      boot.initrd.kernelModules = [ ];
      boot.kernelModules = [ "kvm-amd" ];
      boot.extraModulePackages = [ ];
      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
      hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };

  flake.nixosConfigurations.fomonix = inputs.nixpkgs.lib.nixosSystem {
    modules = commonModules ++ [
      self.nixosModules.niri
      self.nixosModules.dmsConfigNiri   # replaces noctaliaConfigNiri
      self.nixosModules.kittyNiri
      self.nixosModules.ghosttyNiri
      self.nixosModules.footNiri
      self.nixosModules.nixvimNiri
    ];
  };

  flake.nixosConfigurations.fomonixHyprland = inputs.nixpkgs.lib.nixosSystem {
    modules = commonModules ++ [
      self.nixosModules.hyprland
      self.nixosModules.noctaliaConfigHyprland
      self.nixosModules.kittyHyprland
      self.nixosModules.ghosttyHyprland
      self.nixosModules.footHyprland
      self.nixosModules.nixvimHyprland
    ];
  };
}
