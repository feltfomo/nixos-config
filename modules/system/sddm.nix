{
  config,
  pkgs,
  inputs,
  vars,
  ...
}:
{
  imports = [ inputs.silentSDDM.nixosModules.default ];

  programs.silentSDDM = {
    enable = true;
    theme = "rei";
    profileIcons = {
      ${vars.username} = vars.avatarPath;
    };
  };
}
