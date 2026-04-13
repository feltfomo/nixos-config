{ ... }:
let vars = import ./../_config.nix;
in {
  flake.nixosModules.qt = { pkgs, ... }:
  let theme = import ./_theme.nix { inherit pkgs; };
  in {
    environment.systemPackages = [ pkgs.qt6Packages.qt6ct ];
    qt = {
      enable = true;
      platformTheme = "qt5ct";
    };
    hjem.users.${vars.username}.files = {
      ".config/qt6ct/qt6ct.conf".text = ''
        [Appearance]
        color_scheme_path=${vars.home}/.config/qt6ct/colors/noctalia.conf
        custom_palette=true
        icon_theme=${theme.icons.name}
        style=Fusion

        [Fonts]
        fixed="${theme.font.name},11,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"
        general="${theme.sansFont.name},11,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"
      '';
    };
  };
}
