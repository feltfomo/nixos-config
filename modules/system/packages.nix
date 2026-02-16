{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # System tools
    wget
    git
    vim
    # Nix tooling
    nixfmt
    nil
    # Led Control
    ckb-next
    # Hyprland plugins
    pkgs.hyprlandPlugins.hyprexpo
  ];

  services.udev.packages = [ pkgs.ckb-next ];

  systemd.services.ckb-next-daemon = {
    description = "Corsair Keyboard Daemon (ckb-next)";
    wantedBy = [ "multi-user.target" ];
    after = [
      "network.target"
      "systemd-udev-settle.service"
    ];
    requires = [ "systemd-udev-settle.service" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.ckb-next}/bin/ckb-next-daemon";
      Restart = "on-failure";
      RestartSec = 2;
      RuntimeDirectory = "ckb-next";
    };
  };

  nixpkgs.config.allowUnfree = true;
}
