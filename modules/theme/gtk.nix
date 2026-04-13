{ ... }:
let vars = import ./../_config.nix;
in {
  flake.nixosModules.gtk = { pkgs, ... }:
  let theme = import ./_theme.nix { inherit pkgs; };
  in {
    environment.systemPackages = [
      pkgs.adw-gtk3
      theme.icons.package
    ];
    hjem.users.${vars.username}.files = {
      ".config/gtk-3.0/settings.ini".text = ''
        [Settings]
        gtk-theme-name=adw-gtk3
        gtk-icon-theme-name=${theme.icons.name}
        gtk-font-name=${theme.font.name} 11
        gtk-cursor-theme-name=${theme.cursor.name}
        gtk-cursor-theme-size=${toString theme.cursor.size}
        gtk-application-prefer-dark-theme=1
      '';
      ".config/gtk-4.0/settings.ini".text = ''
        [Settings]
        gtk-theme-name=adw-gtk3
        gtk-icon-theme-name=${theme.icons.name}
        gtk-font-name=${theme.font.name} 11
        gtk-cursor-theme-name=${theme.cursor.name}
        gtk-cursor-theme-size=${toString theme.cursor.size}
        gtk-application-prefer-dark-theme=1
      '';
      ".config/gtk-3.0/gtk.css".text = ''
        @import url("noctalia.css");
      '';
      ".config/gtk-4.0/gtk.css".text = ''
        @import url("noctalia.css");
      '';
    };
  };
}
