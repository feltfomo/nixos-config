{ ... }:
let vars = import ./../_config.nix;
in {
  flake.nixosModules.cursor = { pkgs, ... }:
  {
    environment.systemPackages = [ pkgs.rose-pine-hyprcursor ];
    environment.sessionVariables = {
      XCURSOR_THEME = "rose-pine-hyprcursor";
      XCURSOR_SIZE = "24";
    };
    hjem.users.${vars.username}.files.".icons/default/index.theme".text = ''
      [Icon Theme]
      Name=Default
      Comment=Default Cursor Theme
      Inherits=rose-pine-hyprcursor
    '';
  };
}
