{ config, pkgs, ... }:
let
  catppuccin-grub = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "grub";
    rev = "0a37ab19f654e77129b409fed371891c01ffd0b9";
    sha256 = "sha256-jgM22pvCQvb0bjQQXoiqGMgScR9AgCK3OfDF5Ud+/mk=";
  };
in
{
  boot = {
    kernelPackages = pkgs.linuxPackages_zen;
    loader = {
      systemd-boot.enable = false;
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        useOSProber = false;
        configurationLimit = 10;
        theme = catppuccin-grub + "/src/catppuccin-mocha-grub-theme";
        extraEntries = ''
          menuentry "Windows" --class windows11 {
            insmod part_gpt
            insmod fat
            insmod chain
            search --no-floppy --fs-uuid --set=root 788A-64D6
            chainloader /efi/Microsoft/Boot/bootmgfw.efi
          }

          menuentry "Arch Linux" --class archlinux {
            insmod part_gpt
            insmod ext2
            search --no-floppy --fs-uuid --set=root 1baf6481-e9b8-4c2c-bc60-c14dd40ab818
            linux /boot/vmlinuz-linux root=UUID=1baf6481-e9b8-4c2c-bc60-c14dd40ab818 rw quiet
            initrd /boot/initramfs-linux.img
          }
        '';
      };
    };
  };
}
