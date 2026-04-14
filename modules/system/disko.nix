{ ... }:
let
  vars = import ./../_config.nix;
in
{
  flake.nixosModules.disko = {
    fileSystems = {
      "/" = {
        device = "/dev/disk/by-uuid/${vars.disk.rootUuid}";
        fsType = "btrfs";
        options = [
          "subvol=@"
          "compress=zstd"
          "noatime"
        ];
      };
      "/nix" = {
        device = "/dev/disk/by-uuid/${vars.disk.rootUuid}";
        fsType = "btrfs";
        options = [
          "subvol=@nix"
          "compress=zstd"
          "noatime"
        ];
      };
      "/persist" = {
        device = "/dev/disk/by-uuid/${vars.disk.rootUuid}";
        fsType = "btrfs";
        options = [
          "subvol=@persist"
          "compress=zstd"
          "noatime"
        ];
        neededForBoot = true;
      };
      "/home" = {
        device = "/dev/disk/by-uuid/${vars.disk.rootUuid}";
        fsType = "btrfs";
        options = [
          "subvol=@home"
          "compress=zstd"
          "noatime"
        ];
        neededForBoot = true;
      };
      "/boot" = {
        device = "/dev/disk/by-uuid/${vars.disk.bootUuid}";
        fsType = "vfat";
        options = [ "umask=0077" ];
      };
    };
    swapDevices = [
      { device = "/dev/disk/by-uuid/${vars.disk.swapUuid}"; }
    ];
  };
}
