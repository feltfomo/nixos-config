{ ... }:
let vars = import ./../_config.nix;
in {
  flake.nixosModules.impermanence = {
    boot.initrd.systemd.enable = true;
    boot.initrd.systemd.services.wipe-root = {
      description = "Wipe / on boot via btrfs snapshot restore";
      wantedBy = [ "initrd.target" ];
      after = [ "dev-disk-by\\x2duuid-759ce480\\x2d777a\\x2d455e\\x2d98c9\\x2de0009ee31f8b.device" ];
      before = [ "sysroot.mount" ];
      unitConfig.DefaultDependencies = false;
      serviceConfig.Type = "oneshot";
      script = ''
        mkdir -p /mnt

        mount -o subvol=/ /dev/disk/by-uuid/759ce480-777a-455e-98c9-e0009ee31f8b /mnt

        if [ -e /mnt/@old ]; then
          btrfs subvolume delete /mnt/@old
        fi

        btrfs subvolume snapshot /mnt/@ /mnt/@old
        btrfs subvolume delete /mnt/@
        btrfs subvolume snapshot /mnt/@blank /mnt/@

        umount /mnt
      '';
    };
    environment.persistence."/persist" = {
      hideMounts = true;
      directories = [
        "/var/log"
        "/var/lib/bluetooth"
        "/var/lib/nixos"
        "/var/lib/systemd/coredump"
        "/var/lib/systemd/timers"
        "/var/lib/upower"
        "/var/lib/sddm"
        "/var/lib/power-profiles-daemon"
        "/etc/NetworkManager/system-connections"
        "/etc/nixos"
      ];
      files = [
        "/etc/machine-id"
        "/etc/ssh/ssh_host_ed25519_key"
        "/etc/ssh/ssh_host_ed25519_key.pub"
        "/etc/ssh/ssh_host_rsa_key"
        "/etc/ssh/ssh_host_rsa_key.pub"
      ];
    };
    security.sudo.extraConfig = "Defaults lecture=never";
    systemd.tmpfiles.rules = [
      "d /persist/home 0777 root root -"
      "d /persist/home/${vars.username} 0700 ${vars.username} users -"
      "d /persist/passwords 0700 root root -"
    ];
  };
}
