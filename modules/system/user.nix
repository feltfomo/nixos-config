{
  config,
  pkgs,
  vars,
  ...
}:
{
  # Locale
  time.timeZone = vars.timezone;
  i18n.defaultLocale = vars.locale;

  # User
  users.users.${vars.username} = {
    isNormalUser = true;
    description = vars.username;
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "audio"
    ];
    shell = pkgs.zsh;
  };
}
