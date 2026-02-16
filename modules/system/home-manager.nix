{
  config,
  pkgs,
  inputs,
  ...
}:
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    backupFileExtension = "backup";
    users.zynth = {
      imports = [ ../../home.nix ];
      systemd.user.startServices = "sd-switch";
    };
  };
}
