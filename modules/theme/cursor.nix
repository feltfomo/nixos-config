{ ... }:
let vars = import ./../_config.nix;
in {
  flake.nixosModules.cursor = { pkgs, ... }:
  let theme = import ./_theme.nix { inherit pkgs; };
  in {
    environment.systemPackages = [ theme.cursor.package ];
    environment.sessionVariables = {
      XCURSOR_THEME = theme.cursor.name;
      XCURSOR_SIZE = toString theme.cursor.size;
    };
    hjem.users.${vars.username}.files.".icons/default/index.theme".text = ''
      [Icon Theme]
      Name=Default
      Comment=Default Cursor Theme
      Inherits=${theme.cursor.name}
    '';
  };
}
