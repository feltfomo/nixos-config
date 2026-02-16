{
  config,
  pkgs,
  inputs,
  vars,
  ...
}:
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs vars; };
    backupFileExtension = "backup";
    users.${vars.username} = {
      imports = [ ../../home.nix ];
      systemd.user.startServices = "sd-switch";
    };
  };
}
