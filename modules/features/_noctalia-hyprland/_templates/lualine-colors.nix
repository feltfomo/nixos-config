{ ... }:
let
  vars = import ./../../../_config.nix;
in
{
  hjem.users.${vars.username}.files = {
    ".config-hyprland/noctalia/templates/lualine-colors.lua".text = ''
      local function darken(hex, amount)
        local r = tonumber(hex:sub(2,3), 16)
        local g = tonumber(hex:sub(4,5), 16)
        local b = tonumber(hex:sub(6,7), 16)
        r = math.max(0, math.floor(r * amount))
        g = math.max(0, math.floor(g * amount))
        b = math.max(0, math.floor(b * amount))
        return string.format("#%02x%02x%02x", r, g, b)
      end

      local primary = "{{colors.primary.default.hex}}"

      local c = {
        bg       = darken(primary, 0.15),
        bg_mid   = darken(primary, 0.25),
        fg       = "{{colors.on_surface.default.hex}}",
        fg_muted = "{{colors.on_surface_variant.default.hex}}",
        primary  = "{{colors.primary.default.hex}}",
        secondary= "{{colors.secondary.default.hex}}",
        tertiary = "{{colors.tertiary.default.hex}}",
        error    = "{{colors.error.default.hex}}",
      }

      require("lualine").setup({
        options = {
          theme = {
            normal   = { a = { fg = c.bg, bg = c.primary,   gui = "bold" }, b = { fg = c.fg, bg = c.bg_mid }, c = { fg = c.fg, bg = c.bg } },
            insert   = { a = { fg = c.bg, bg = c.secondary, gui = "bold" }, b = { fg = c.fg, bg = c.bg_mid }, c = { fg = c.fg, bg = c.bg } },
            visual   = { a = { fg = c.bg, bg = c.tertiary,  gui = "bold" }, b = { fg = c.fg, bg = c.bg_mid }, c = { fg = c.fg, bg = c.bg } },
            replace  = { a = { fg = c.bg, bg = c.error,     gui = "bold" }, b = { fg = c.fg, bg = c.bg_mid }, c = { fg = c.fg, bg = c.bg } },
            inactive = { a = { fg = c.fg_muted, bg = c.bg }, b = { fg = c.fg_muted, bg = c.bg }, c = { fg = c.fg_muted, bg = c.bg } },
          },
        },
      })
    '';
  };
}
