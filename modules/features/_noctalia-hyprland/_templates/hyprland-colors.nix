{ ... }:
let
  vars = import ./../../../_config.nix;
in
{
  hjem.users.${vars.username}.files = {
    ".config-hyprland/noctalia/templates/hyprland-colors.conf".text = ''
      $active_border = rgba({{colors.primary.default.hex_stripped}}ff)
      $inactive_border = rgba({{colors.surface_variant.default.hex_stripped}}ff)
    '';
  };
}
