{ ... }:
let
  vars = import ./../../../_config.nix;
in
{
  hjem.users.${vars.username}.files = {
    ".config-hyprland/noctalia/templates/foot-colors.ini".text = ''
      [colors-dark]
      foreground={{colors.on_surface.default.hex_stripped}}
      background={{colors.surface.default.hex_stripped}}
      selection-foreground={{colors.on_surface.default.hex_stripped}}
      selection-background={{colors.surface_variant.default.hex_stripped}}

      regular0={{colors.surface_variant.default.hex_stripped}}
      regular1={{colors.error.default.hex_stripped}}
      regular2={{colors.secondary.default.hex_stripped}}
      regular3={{colors.tertiary.default.hex_stripped}}
      regular4={{colors.primary.default.hex_stripped}}
      regular5={{colors.primary_container.default.hex_stripped}}
      regular6={{colors.secondary_container.default.hex_stripped}}
      regular7={{colors.on_surface.default.hex_stripped}}

      bright0={{colors.on_surface_variant.default.hex_stripped}}
      bright1={{colors.error.default.hex_stripped}}
      bright2={{colors.secondary.default.hex_stripped}}
      bright3={{colors.tertiary.default.hex_stripped}}
      bright4={{colors.primary.default.hex_stripped}}
      bright5={{colors.primary_container.default.hex_stripped}}
      bright6={{colors.secondary_container.default.hex_stripped}}
      bright7={{colors.on_surface.default.hex_stripped}}
    '';
  };
}
