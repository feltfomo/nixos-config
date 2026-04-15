{ ... }:
let
  vars = import ./../../../_config.nix;
in
{
  hjem.users.${vars.username}.files = {
    ".config/matugen/templates/kitty-dms-colors.conf".text = ''
      foreground              {{colors.on_surface.default.hex}}
      background              {{colors.surface.default.hex}}
      selection_foreground    {{colors.on_surface.default.hex}}
      selection_background    {{colors.surface_variant.default.hex}}
      cursor                  {{colors.on_surface.default.hex}}
      cursor_text_color       {{colors.surface.default.hex}}
      url_color               {{colors.tertiary.default.hex}}
      active_tab_foreground   {{colors.on_surface.default.hex}}
      active_tab_background   {{colors.surface_variant.default.hex}}
      inactive_tab_foreground {{colors.on_surface_variant.default.hex}}
      inactive_tab_background {{colors.surface.default.hex}}
      active_border_color     {{colors.primary.default.hex}}
      inactive_border_color   {{colors.surface_variant.default.hex}}
      color0  {{colors.surface.default.hex}}
      color8  {{colors.surface_variant.default.hex}}
      color1  {{colors.error.default.hex}}
      color9  {{colors.error_container.default.hex}}
      color2  {{colors.tertiary.default.hex}}
      color10 {{colors.tertiary_container.default.hex}}
      color3  {{colors.secondary.default.hex}}
      color11 {{colors.secondary_container.default.hex}}
      color4  {{colors.primary.default.hex}}
      color12 {{colors.primary_container.default.hex}}
      color5  {{colors.tertiary.default.hex}}
      color13 {{colors.tertiary_container.default.hex}}
      color6  {{colors.secondary.default.hex}}
      color14 {{colors.secondary_container.default.hex}}
      color7  {{colors.on_surface.default.hex}}
      color15 {{colors.on_surface_variant.default.hex}}
    '';
  };
}
