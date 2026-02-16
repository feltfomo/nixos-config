{ config, pkgs, inputs, lib, ... }:
{
  programs.dank-material-shell = {
    enable = true;
    systemd = {
      enable = true;
      restartIfChanged = true;
    };
    enableSystemMonitoring = true;
    enableVPN = true;
    enableAudioWavelength = true;
    enableCalendarEvents = true;
  };

  systemd.user.services.dms.Service = {
    ExecStart = lib.mkForce "${inputs.dms.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/dms run --session";
    ExecReload = lib.mkForce "${pkgs.procps}/bin/pkill -USR1 -x dms";
  };
}