{ lib, ... }:
let
  vars = import ./../../_config.nix;
in
{
  hjem.users.${vars.username}.files = {

    ".config-hyprland/noctalia/plugins.json" = {
      generator = lib.generators.toJSON { };
      value = {
        version = 2;
        sources = [
          { enabled = true; name = "Noctalia Plugins"; url = "https://github.com/noctalia-dev/noctalia-plugins"; }
        ];
        states = {
          clipper          = { enabled = true; sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins"; };
          keybind-cheatsheet = { enabled = true; sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins"; };
          zed-provider     = { enabled = true; sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins"; };
          submap-osd       = { enabled = true; sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins"; };
        };
      };
    };

    ".config-hyprland/noctalia/plugins/keybind-cheatsheet/settings.json" = {
      generator = lib.generators.toJSON { };
      value = {
        cheatsheetData = [ ];
        detectedCompositor = "hyprland";
      };
    };

  };
}
