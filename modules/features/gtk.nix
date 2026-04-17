{ ... }:
let vars = import ./../_config.nix;
in {
  flake.nixosModules.gtk = { pkgs, ... }:
  {
    environment.systemPackages = [
      pkgs.adw-gtk3
      pkgs.papirus-icon-theme
    ];
    hjem.users.${vars.username}.files = {
      ".config/gtk-3.0/settings.ini".text = ''
        [Settings]
        gtk-theme-name=adw-gtk3
        gtk-icon-theme-name=Papirus-Dark
        gtk-font-name=Inter 11
        gtk-cursor-theme-name=rose-pine-hyprcursor
        gtk-cursor-theme-size=24
        gtk-application-prefer-dark-theme=1
      '';
      ".config/gtk-4.0/settings.ini".text = ''
        [Settings]
        gtk-theme-name=adw-gtk3
        gtk-icon-theme-name=Papirus-Dark
        gtk-font-name=Inter 11
        gtk-cursor-theme-name=rose-pine-hyprcursor
        gtk-cursor-theme-size=24
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
