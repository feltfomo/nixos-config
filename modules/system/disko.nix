{ ... }:
{
  flake.nixosModules.disko = {
    fileSystems = {
      "/" = {
        device = "/dev/disk/by-uuid/759ce480-777a-455e-98c9-e0009ee31f8b";
        fsType = "btrfs";
        options = [ "subvol=@" "compress=zstd" "noatime" ];
      };
      "/nix" = {
        device = "/dev/disk/by-uuid/759ce480-777a-455e-98c9-e0009ee31f8b";
        fsType = "btrfs";
        options = [ "subvol=@nix" "compress=zstd" "noatime" ];
      };
      "/persist" = {
        device = "/dev/disk/by-uuid/759ce480-777a-455e-98c9-e0009ee31f8b";
        fsType = "btrfs";
        options = [ "subvol=@persist" "compress=zstd" "noatime" ];
        neededForBoot = true;
      };
      "/home" = {
        device = "/dev/disk/by-uuid/759ce480-777a-455e-98c9-e0009ee31f8b";
        fsType = "btrfs";
        options = [ "subvol=@home" "compress=zstd" "noatime" ];
      };
      "/boot" = {
        device = "/dev/disk/by-uuid/F442-EF75";
        fsType = "vfat";
        options = [ "umask=0077" ];
      };
    };

    swapDevices = [
      { device = "/dev/disk/by-uuid/02a6abfd-9d76-4ddc-ae20-dc028580c206"; }
    ];
  };
}
