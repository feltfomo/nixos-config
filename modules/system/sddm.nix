{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [ inputs.silentSDDM.nixosModules.default ];

  programs.silentSDDM = {
    enable = true;
    theme = "rei";
    profileIcons = {
      zynth = "/home/zynth/Pictures/avatar.jpg";
    };
  };
}
