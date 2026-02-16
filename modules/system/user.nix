{ config, pkgs, ... }:
{
  # Locale
  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_US.UTF-8";

  # User
  users.users.zynth = {
    isNormalUser = true;
    description = "zynth";
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "audio"
    ];
    shell = pkgs.zsh;
  };
}
