{ ... }:
let
  vars = import ./../../../_config.nix;
in
{
  hjem.users.${vars.username}.files = {
    ".config/matugen/templates/niri-dms-colors.kdl".text = ''
      layout {
        border {
          active-color "{{colors.primary.default.hex}}"
          inactive-color "{{colors.surface_variant.default.hex}}"
        }
      }
    '';
  };
}
