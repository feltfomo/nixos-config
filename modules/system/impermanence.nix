{ ... }:
let
  vars = import ./../_config.nix;
  # Systemd unit name encoding: hyphens in UUIDs become \x2d in device unit names.
  rootUuidEscaped = builtins.replaceStrings [ "-" ] [ "\\x2d" ] vars.disk.rootUuid;
in
{
  flake.nixosModules.impermanence = {
    boot.initrd.systemd.enable = true;
    boot.initrd.systemd.services.wipe-root = {
      description = "Wipe / on boot via btrfs snapshot restore";
      wantedBy = [ "initrd.target" ];
      after = [ "dev-disk-by\\x2duuid-${rootUuidEscaped}.device" ];
      before = [ "sysroot.mount" ];
      unitConfig.DefaultDependencies = false;
      serviceConfig.Type = "oneshot";
      script = ''
        mkdir -p /mnt
        mount -o subvol=/ /dev/disk/by-uuid/${vars.disk.rootUuid} /mnt
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
      users.${vars.username} = {
        directories = [
          ".local/share/icons"
        ];
      };
    };
    security.sudo.extraConfig = "Defaults lecture=never";
    systemd.tmpfiles.rules = [
      "d /persist/home 0777 root root -"
      "d /persist/home/${vars.username} 0700 ${vars.username} users -"
      "d /persist/passwords 0700 root root -"
    ];
  };
}
