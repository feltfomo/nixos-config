{ ... }:
let
  vars = import ./../../../_config.nix;
in
{
  hjem.users.${vars.username}.files = {
    ".config-hyprland/noctalia/templates/satty.css".text = ''
      .outer_box, .toolbar {
        color: {{colors.on_surface.default.hex}};
        background-color: {{colors.surface.default.hex}};
      }
    '';
  };
}
