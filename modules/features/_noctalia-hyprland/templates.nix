{ ... }:
let
  vars = import ./../../_config.nix;
in
{
  hjem.users.${vars.username}.files = {

    ".config-hyprland/noctalia/user-templates.toml".text = ''
      [config]

      [templates.kitty]
      input_path = "~/.config-hyprland/noctalia/templates/kitty-colors.conf"
      output_path = "~/.config/kitty/noctalia-colors.conf"
      post_hook = "kill -USR1 $(pidof kitty) 2>/dev/null; true"

      [templates.hyprland]
      input_path = "~/.config-hyprland/noctalia/templates/hyprland-colors.conf"
      output_path = "~/.config/hypr/noctalia-colors.conf"
      post_hook = "hyprctl reload 2>/dev/null; true"

      [templates.zed]
      input_path = "~/.config-hyprland/noctalia/templates/zed-theme.json"
      output_path = "~/.config/zed/themes/noctalia.json"
      post_hook = "true"

      [templates.satty]
      input_path = "~/.config-hyprland/noctalia/templates/satty.css"
      output_path = "~/.config/satty/overrides.css"
      post_hook = "true"

      [templates.nvim]
      input_path = "~/.config-hyprland/noctalia/templates/nvim-colors.lua"
      output_path = "~/.config/nvim/noctalia-colors.lua"
      post_hook = "nvim --server /tmp/nvim.sock --remote-send '<cmd>source ~/.config/nvim/noctalia-colors.lua<cr>' 2>/dev/null; true"

      [templates.lualine]
      input_path = "~/.config-hyprland/noctalia/templates/lualine-colors.lua"
      output_path = "~/.config/nvim/lualine-colors.lua"
      post_hook = "nvim --server /tmp/nvim.sock --remote-send '<cmd>source ~/.config/nvim/lualine-colors.lua<cr>' 2>/dev/null; true"
    '';

    ".config-hyprland/noctalia/templates/kitty-colors.conf".text = ''
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
      # black
      color0  {{colors.surface_variant.default.hex}}
      color8  {{colors.on_surface_variant.default.hex}}
      # red
      color1  {{colors.error.default.hex}}
      color9  {{colors.error.default.hex}}
      # green
      color2  {{colors.secondary.default.hex}}
      color10 {{colors.secondary.default.hex}}
      # yellow
      color3  {{colors.tertiary.default.hex}}
      color11 {{colors.tertiary.default.hex}}
      # blue
      color4  {{colors.primary.default.hex}}
      color12 {{colors.primary.default.hex}}
      # magenta
      color5  {{colors.primary_container.default.hex}}
      color13 {{colors.primary_container.default.hex}}
      # cyan
      color6  {{colors.secondary_container.default.hex}}
      color14 {{colors.secondary_container.default.hex}}
      # white
      color7  {{colors.on_surface.default.hex}}
      color15 {{colors.on_surface.default.hex}}
    '';

    ".config-hyprland/noctalia/templates/hyprland-colors.conf".text = ''
      $active_border = rgba({{colors.primary.default.hex_stripped}}ff)
      $inactive_border = rgba({{colors.surface_variant.default.hex_stripped}}ff)
    '';

    ".config-hyprland/noctalia/templates/zed-theme.json".text = ''
      {
        "$schema": "https://zed.dev/schema/themes/v0.2.0.json",
        "name": "Noctalia",
        "author": "noctalia",
        "themes": [
          {
            "name": "Noctalia Dark",
            "appearance": "dark",
            "style": {
              "background": "{{colors.surface.default.hex}}",
              "background.appearance": "opaque",

              "border": "{{colors.outline_variant.default.hex}}",
              "border.variant": "{{colors.outline_variant.default.hex}}",
              "border.focused": "{{colors.primary.default.hex}}",
              "border.selected": "{{colors.primary.default.hex}}",
              "border.transparent": "{{colors.surface.default.hex}}00",
              "border.disabled": "{{colors.outline_variant.default.hex}}50",

              "elevated_surface.background": "{{colors.surface_container_high.default.hex}}",
              "surface.background": "{{colors.surface_variant.default.hex}}",
              "panel.background": "{{colors.surface.default.hex}}",
              "panel.focused_border": "{{colors.primary.default.hex}}",
              "panel.indent_guide": "{{colors.outline_variant.default.hex}}40",
              "panel.indent_guide_active": "{{colors.outline.default.hex}}",
              "panel.indent_guide_hover": "{{colors.outline_variant.default.hex}}80",

              "pane.focused_border": "{{colors.primary.default.hex}}",
              "pane_group.border": "{{colors.outline_variant.default.hex}}",

              "tab_bar.background": "{{colors.surface.default.hex}}",
              "tab.active_background": "{{colors.surface_variant.default.hex}}",
              "tab.inactive_background": "{{colors.surface.default.hex}}",
              "toolbar.background": "{{colors.surface.default.hex}}",
              "title_bar.background": "{{colors.surface.default.hex}}",
              "title_bar.inactive_background": "{{colors.surface_variant.default.hex}}",
              "status_bar.background": "{{colors.surface.default.hex}}",

              "text": "{{colors.on_surface.default.hex}}",
              "text.muted": "{{colors.on_surface_variant.default.hex}}",
              "text.placeholder": "{{colors.on_surface_variant.default.hex}}80",
              "text.disabled": "{{colors.on_surface_variant.default.hex}}50",
              "text.accent": "{{colors.primary.default.hex}}",

              "icon": "{{colors.on_surface_variant.default.hex}}",
              "icon.muted": "{{colors.on_surface_variant.default.hex}}80",
              "icon.disabled": "{{colors.on_surface_variant.default.hex}}50",
              "icon.placeholder": "{{colors.on_surface_variant.default.hex}}60",
              "icon.accent": "{{colors.primary.default.hex}}",

              "element.background": "{{colors.surface_variant.default.hex}}",
              "element.hover": "{{colors.surface_variant.default.hex}}80",
              "element.active": "{{colors.primary.default.hex}}50",
              "element.selected": "{{colors.primary.default.hex}}30",
              "element.disabled": "{{colors.surface_variant.default.hex}}40",

              "ghost_element.background": "{{colors.surface.default.hex}}00",
              "ghost_element.hover": "{{colors.surface_variant.default.hex}}80",
              "ghost_element.active": "{{colors.primary.default.hex}}50",
              "ghost_element.selected": "{{colors.primary.default.hex}}30",
              "ghost_element.disabled": "{{colors.surface_variant.default.hex}}40",

              "drop_target.background": "{{colors.primary.default.hex}}20",

              "editor.background": "{{colors.surface.default.hex}}",
              "editor.foreground": "{{colors.on_surface.default.hex}}",
              "editor.gutter.background": "{{colors.surface.default.hex}}",
              "editor.subheader.background": "{{colors.surface_variant.default.hex}}",
              "editor.active_line.background": "{{colors.surface_variant.default.hex}}40",
              "editor.highlighted_line.background": "{{colors.primary.default.hex}}15",
              "editor.line_number": "{{colors.on_surface_variant.default.hex}}",
              "editor.active_line_number": "{{colors.on_surface.default.hex}}",
              "editor.hover_line_number": "{{colors.on_surface.default.hex}}80",
              "editor.invisible": "{{colors.on_surface_variant.default.hex}}40",
              "editor.wrap_guide": "{{colors.outline_variant.default.hex}}40",
              "editor.active_wrap_guide": "{{colors.outline_variant.default.hex}}80",
              "editor.indent_guide": "{{colors.outline_variant.default.hex}}40",
              "editor.indent_guide_active": "{{colors.outline.default.hex}}",
              "editor.document_highlight.read_background": "{{colors.primary.default.hex}}20",
              "editor.document_highlight.write_background": "{{colors.secondary.default.hex}}20",
              "editor.document_highlight.bracket_background": "{{colors.tertiary.default.hex}}20",

              "terminal.background": "{{colors.surface.default.hex}}",
              "terminal.foreground": "{{colors.on_surface.default.hex}}",
              "terminal.bright_foreground": "{{colors.on_surface.default.hex}}",
              "terminal.dim_foreground": "{{colors.on_surface_variant.default.hex}}",
              "terminal.ansi.background": "{{colors.surface.default.hex}}",
              "terminal.ansi.black": "{{colors.surface_variant.default.hex}}",
              "terminal.ansi.bright_black": "{{colors.on_surface_variant.default.hex}}",
              "terminal.ansi.dim_black": "{{colors.surface_variant.default.hex}}80",
              "terminal.ansi.red": "{{colors.error.default.hex}}",
              "terminal.ansi.bright_red": "{{colors.error.default.hex}}",
              "terminal.ansi.dim_red": "{{colors.error.default.hex}}80",
              "terminal.ansi.green": "{{colors.secondary.default.hex}}",
              "terminal.ansi.bright_green": "{{colors.secondary.default.hex}}",
              "terminal.ansi.dim_green": "{{colors.secondary.default.hex}}80",
              "terminal.ansi.yellow": "{{colors.tertiary.default.hex}}",
              "terminal.ansi.bright_yellow": "{{colors.tertiary.default.hex}}",
              "terminal.ansi.dim_yellow": "{{colors.tertiary.default.hex}}80",
              "terminal.ansi.blue": "{{colors.primary.default.hex}}",
              "terminal.ansi.bright_blue": "{{colors.primary.default.hex}}",
              "terminal.ansi.dim_blue": "{{colors.primary.default.hex}}80",
              "terminal.ansi.magenta": "{{colors.primary_container.default.hex}}",
              "terminal.ansi.bright_magenta": "{{colors.primary_container.default.hex}}",
              "terminal.ansi.dim_magenta": "{{colors.primary_container.default.hex}}80",
              "terminal.ansi.cyan": "{{colors.secondary_container.default.hex}}",
              "terminal.ansi.bright_cyan": "{{colors.secondary_container.default.hex}}",
              "terminal.ansi.dim_cyan": "{{colors.secondary_container.default.hex}}80",
              "terminal.ansi.white": "{{colors.on_surface.default.hex}}",
              "terminal.ansi.bright_white": "{{colors.on_surface.default.hex}}",
              "terminal.ansi.dim_white": "{{colors.on_surface.default.hex}}80",

              "scrollbar.thumb.background": "{{colors.outline_variant.default.hex}}",
              "scrollbar.thumb.hover_background": "{{colors.outline.default.hex}}",
              "scrollbar.thumb.active_background": "{{colors.primary.default.hex}}",
              "scrollbar.thumb.border": "{{colors.surface.default.hex}}00",
              "scrollbar.track.background": "{{colors.surface.default.hex}}00",
              "scrollbar.track.border": "{{colors.outline_variant.default.hex}}20",

              "search.match_background": "{{colors.primary.default.hex}}30",
              "search.active_match_background": "{{colors.primary.default.hex}}60",
              "link_text.hover": "{{colors.primary.default.hex}}",

              "version_control.added": "{{colors.secondary.default.hex}}",
              "version_control.modified": "{{colors.primary.default.hex}}",
              "version_control.deleted": "{{colors.error.default.hex}}",

              "conflict": "{{colors.tertiary.default.hex}}",
              "conflict.background": "{{colors.tertiary.default.hex}}15",
              "conflict.border": "{{colors.tertiary.default.hex}}50",
              "created": "{{colors.secondary.default.hex}}",
              "created.background": "{{colors.secondary.default.hex}}15",
              "created.border": "{{colors.secondary.default.hex}}50",
              "deleted": "{{colors.error.default.hex}}",
              "deleted.background": "{{colors.error.default.hex}}15",
              "deleted.border": "{{colors.error.default.hex}}50",
              "modified": "{{colors.primary.default.hex}}",
              "modified.background": "{{colors.primary.default.hex}}15",
              "modified.border": "{{colors.primary.default.hex}}50",
              "renamed": "{{colors.secondary.default.hex}}",
              "renamed.background": "{{colors.secondary.default.hex}}15",
              "renamed.border": "{{colors.secondary.default.hex}}50",
              "hidden": "{{colors.on_surface_variant.default.hex}}80",
              "hidden.background": "{{colors.surface.default.hex}}",
              "hidden.border": "{{colors.outline_variant.default.hex}}",
              "ignored": "{{colors.on_surface_variant.default.hex}}60",
              "ignored.background": "{{colors.surface.default.hex}}",
              "ignored.border": "{{colors.outline_variant.default.hex}}",

              "error": "{{colors.error.default.hex}}",
              "error.background": "{{colors.error.default.hex}}15",
              "error.border": "{{colors.error.default.hex}}50",
              "warning": "{{colors.tertiary.default.hex}}",
              "warning.background": "{{colors.tertiary.default.hex}}15",
              "warning.border": "{{colors.tertiary.default.hex}}50",
              "success": "{{colors.secondary.default.hex}}",
              "success.background": "{{colors.secondary.default.hex}}15",
              "success.border": "{{colors.secondary.default.hex}}50",
              "info": "{{colors.primary.default.hex}}",
              "info.background": "{{colors.primary.default.hex}}15",
              "info.border": "{{colors.primary.default.hex}}50",
              "hint": "{{colors.on_surface_variant.default.hex}}",
              "hint.background": "{{colors.surface_variant.default.hex}}",
              "hint.border": "{{colors.outline_variant.default.hex}}",
              "predictive": "{{colors.on_surface_variant.default.hex}}80",
              "predictive.background": "{{colors.surface.default.hex}}00",
              "predictive.border": "{{colors.surface.default.hex}}00",
              "unreachable": "{{colors.on_surface_variant.default.hex}}50",
              "unreachable.background": "{{colors.surface.default.hex}}",
              "unreachable.border": "{{colors.outline_variant.default.hex}}",

              "players": [
                { "cursor": "{{colors.primary.default.hex}}", "background": "{{colors.primary.default.hex}}", "selection": "{{colors.primary.default.hex}}3d" },
                { "cursor": "{{colors.secondary.default.hex}}", "background": "{{colors.secondary.default.hex}}", "selection": "{{colors.secondary.default.hex}}3d" },
                { "cursor": "{{colors.tertiary.default.hex}}", "background": "{{colors.tertiary.default.hex}}", "selection": "{{colors.tertiary.default.hex}}3d" },
                { "cursor": "{{colors.error.default.hex}}", "background": "{{colors.error.default.hex}}", "selection": "{{colors.error.default.hex}}3d" },
                { "cursor": "{{colors.on_surface.default.hex}}", "background": "{{colors.on_surface.default.hex}}", "selection": "{{colors.on_surface.default.hex}}3d" },
                { "cursor": "{{colors.primary_container.default.hex}}", "background": "{{colors.primary_container.default.hex}}", "selection": "{{colors.primary_container.default.hex}}3d" },
                { "cursor": "{{colors.secondary_container.default.hex}}", "background": "{{colors.secondary_container.default.hex}}", "selection": "{{colors.secondary_container.default.hex}}3d" },
                { "cursor": "{{colors.outline.default.hex}}", "background": "{{colors.outline.default.hex}}", "selection": "{{colors.outline.default.hex}}3d" }
              ],

              "syntax": {
                "attribute": { "color": "{{colors.secondary.default.hex}}" },
                "boolean": { "color": "{{colors.primary.default.hex}}" },
                "comment": { "color": "{{colors.on_surface_variant.default.hex}}", "font_style": "italic" },
                "comment.doc": { "color": "{{colors.on_surface_variant.default.hex}}", "font_style": "italic" },
                "constant": { "color": "{{colors.tertiary.default.hex}}" },
                "constructor": { "color": "{{colors.tertiary.default.hex}}" },
                "diff.plus": { "color": "{{colors.secondary.default.hex}}" },
                "diff.minus": { "color": "{{colors.error.default.hex}}" },
                "embedded": { "color": "{{colors.secondary_container.default.hex}}" },
                "emphasis": { "color": "{{colors.primary.default.hex}}", "font_style": "italic" },
                "emphasis.strong": { "color": "{{colors.primary.default.hex}}", "font_weight": 700 },
                "enum": { "color": "{{colors.tertiary.default.hex}}" },
                "function": { "color": "{{colors.tertiary.default.hex}}" },
                "function.builtin": { "color": "{{colors.error.default.hex}}" },
                "function.method": { "color": "{{colors.tertiary.default.hex}}" },
                "hint": { "color": "{{colors.on_surface_variant.default.hex}}" },
                "keyword": { "color": "{{colors.primary.default.hex}}", "font_weight": 700 },
                "label": { "color": "{{colors.secondary.default.hex}}" },
                "link_text": { "color": "{{colors.secondary_container.default.hex}}", "font_style": "italic" },
                "link_uri": { "color": "{{colors.primary_container.default.hex}}" },
                "namespace": { "color": "{{colors.secondary.default.hex}}" },
                "number": { "color": "{{colors.tertiary.default.hex}}" },
                "operator": { "color": "{{colors.primary.default.hex}}" },
                "predictive": { "color": "{{colors.on_surface_variant.default.hex}}80", "font_style": "italic" },
                "preproc": { "color": "{{colors.error.default.hex}}" },
                "primary": { "color": "{{colors.on_surface.default.hex}}" },
                "property": { "color": "{{colors.on_surface.default.hex}}" },
                "punctuation": { "color": "{{colors.on_surface_variant.default.hex}}" },
                "punctuation.bracket": { "color": "{{colors.on_surface_variant.default.hex}}" },
                "punctuation.delimiter": { "color": "{{colors.on_surface_variant.default.hex}}" },
                "punctuation.list_marker": { "color": "{{colors.on_surface.default.hex}}" },
                "punctuation.markup": { "color": "{{colors.secondary.default.hex}}" },
                "punctuation.special": { "color": "{{colors.on_surface_variant.default.hex}}" },
                "selector": { "color": "{{colors.tertiary.default.hex}}" },
                "selector.pseudo": { "color": "{{colors.secondary.default.hex}}" },
                "string": { "color": "{{colors.secondary.default.hex}}" },
                "string.escape": { "color": "{{colors.tertiary.default.hex}}" },
                "string.regex": { "color": "{{colors.tertiary.default.hex}}" },
                "string.special": { "color": "{{colors.primary_container.default.hex}}" },
                "string.special.symbol": { "color": "{{colors.secondary_container.default.hex}}" },
                "tag": { "color": "{{colors.primary.default.hex}}" },
                "text.literal": { "color": "{{colors.secondary.default.hex}}" },
                "title": { "color": "{{colors.tertiary.default.hex}}", "font_weight": 700 },
                "type": { "color": "{{colors.secondary.default.hex}}" },
                "type.builtin": { "color": "{{colors.secondary.default.hex}}", "font_weight": 700 },
                "variable": { "color": "{{colors.on_surface.default.hex}}" },
                "variable.special": { "color": "{{colors.primary.default.hex}}" },
                "variant": { "color": "{{colors.secondary.default.hex}}" }
              }
            }
          }
        ]
      }
    '';

    ".config-hyprland/noctalia/templates/satty.css".text = ''
      .outer_box, .toolbar {
        color: {{colors.on_surface.default.hex}};
        background-color: {{colors.surface.default.hex}};
      }
    '';

    ".config-hyprland/noctalia/templates/nvim-colors.lua".text = ''
      -- generated by noctalia matugen — do not edit manually
      vim.cmd("highlight clear")
      vim.opt.background = "dark"

      local function darken(hex, amount)
        local r = tonumber(hex:sub(2,3), 16)
        local g = tonumber(hex:sub(4,5), 16)
        local b = tonumber(hex:sub(6,7), 16)
        r = math.max(0, math.floor(r * amount))
        g = math.max(0, math.floor(g * amount))
        b = math.max(0, math.floor(b * amount))
        return string.format("#%02x%02x%02x", r, g, b)
      end

      local primary     = "{{colors.primary.default.hex}}"
      local sec_cont    = "{{colors.secondary_container.default.hex}}"

      local c = {
        bg          = darken(primary, 0.15),
        bg_dark     = darken(primary, 0.15),
        bg_highlight= "{{colors.secondary_container.default.hex}}",
        fg          = "{{colors.on_surface.default.hex}}",
        fg_muted    = "{{colors.on_surface_variant.default.hex}}",
        primary     = "{{colors.primary.default.hex}}",
        secondary   = "{{colors.secondary.default.hex}}",
        tertiary    = "{{colors.tertiary.default.hex}}",
        error       = "{{colors.error.default.hex}}",
        outline     = "{{colors.outline.default.hex}}",
        outline_var = "{{colors.outline_variant.default.hex}}",
        p_container = "{{colors.primary_container.default.hex}}",
        s_container = "{{colors.secondary_container.default.hex}}",
      }

      local hi = function(group, opts)
        vim.api.nvim_set_hl(0, group, opts)
      end

      -- editor chrome
      hi("Normal",        { fg = c.fg,       bg = c.bg })
      hi("NormalFloat",   { fg = c.fg,       bg = c.bg_dark })
      hi("FloatBorder",   { fg = c.outline,  bg = c.bg_dark })
      hi("CursorLine",    { bg = c.bg_highlight })
      hi("CursorLineNr",  { fg = c.primary,  bold = true })
      hi("LineNr",        { fg = c.fg_muted })
      hi("SignColumn",    { bg = c.bg })
      hi("StatusLine",    { fg = c.fg,       bg = c.bg_dark })
      hi("StatusLineNC",  { fg = c.fg_muted, bg = c.bg_dark })
      hi("TabLine",       { fg = c.fg_muted, bg = c.bg_dark })
      hi("TabLineSel",    { fg = c.fg,       bg = c.bg_highlight })
      hi("TabLineFill",   { bg = c.bg_dark })
      hi("WinSeparator",  { fg = c.outline_var })
      hi("Pmenu",         { fg = c.fg,       bg = c.bg_dark })
      hi("PmenuSel",      { fg = c.fg,       bg = c.bg_highlight, bold = true })
      hi("PmenuSbar",     { bg = c.bg_dark })
      hi("PmenuThumb",    { bg = c.outline_var })
      hi("Visual",        { bg = c.bg_highlight })
      hi("Search",        { fg = c.bg,       bg = c.primary })
      hi("IncSearch",     { fg = c.bg,       bg = c.tertiary })
      hi("MatchParen",    { fg = c.tertiary, bold = true })

      -- syntax
      hi("Comment",       { fg = c.fg_muted, italic = true })
      hi("Constant",      { fg = c.tertiary })
      hi("String",        { fg = c.secondary })
      hi("Character",     { fg = c.secondary })
      hi("Number",        { fg = c.tertiary })
      hi("Boolean",       { fg = c.primary })
      hi("Float",         { fg = c.tertiary })
      hi("Identifier",    { fg = c.fg })
      hi("Function",      { fg = c.tertiary })
      hi("Statement",     { fg = c.primary,  bold = true })
      hi("Keyword",       { fg = c.primary,  bold = true })
      hi("Conditional",   { fg = c.primary,  bold = true })
      hi("Repeat",        { fg = c.primary,  bold = true })
      hi("Operator",      { fg = c.primary })
      hi("PreProc",       { fg = c.error })
      hi("Include",       { fg = c.primary })
      hi("Define",        { fg = c.primary })
      hi("Type",          { fg = c.secondary })
      hi("StorageClass",  { fg = c.secondary })
      hi("Structure",     { fg = c.secondary })
      hi("Special",       { fg = c.p_container })
      hi("Delimiter",     { fg = c.fg_muted })
      hi("Underlined",    { underline = true })
      hi("Error",         { fg = c.error })
      hi("Todo",          { fg = c.tertiary, bold = true })

      -- treesitter
      hi("@variable",             { fg = c.fg })
      hi("@variable.builtin",     { fg = c.primary })
      hi("@variable.parameter",   { fg = c.fg })
      hi("@variable.member",      { fg = c.fg })
      hi("@constant",             { fg = c.tertiary })
      hi("@constant.builtin",     { fg = c.tertiary })
      hi("@string",               { fg = c.secondary })
      hi("@string.escape",        { fg = c.tertiary })
      hi("@string.special",       { fg = c.p_container })
      hi("@number",               { fg = c.tertiary })
      hi("@boolean",              { fg = c.primary })
      hi("@function",             { fg = c.tertiary })
      hi("@function.builtin",     { fg = c.error })
      hi("@function.method",      { fg = c.tertiary })
      hi("@function.call",        { fg = c.tertiary })
      hi("@keyword",              { fg = c.primary, bold = true })
      hi("@keyword.import",       { fg = c.primary })
      hi("@keyword.return",       { fg = c.primary, bold = true })
      hi("@operator",             { fg = c.primary })
      hi("@punctuation",          { fg = c.fg_muted })
      hi("@punctuation.bracket",  { fg = c.fg_muted })
      hi("@punctuation.delimiter",{ fg = c.fg_muted })
      hi("@type",                 { fg = c.secondary })
      hi("@type.builtin",         { fg = c.secondary, bold = true })
      hi("@namespace",            { fg = c.secondary })
      hi("@attribute",            { fg = c.secondary })
      hi("@constructor",          { fg = c.tertiary })
      hi("@tag",                  { fg = c.primary })
      hi("@tag.attribute",        { fg = c.secondary })
      hi("@tag.delimiter",        { fg = c.fg_muted })
      hi("@comment",              { fg = c.fg_muted, italic = true })
      hi("@markup.heading",       { fg = c.tertiary, bold = true })
      hi("@markup.link",          { fg = c.secondary, italic = true })
      hi("@markup.raw",           { fg = c.s_container })

      -- diagnostics
      hi("DiagnosticError",          { fg = c.error })
      hi("DiagnosticWarn",           { fg = c.tertiary })
      hi("DiagnosticInfo",           { fg = c.primary })
      hi("DiagnosticHint",           { fg = c.fg_muted })
      hi("DiagnosticUnderlineError", { sp = c.error,    underline = true })
      hi("DiagnosticUnderlineWarn",  { sp = c.tertiary, underline = true })
      hi("DiagnosticUnderlineInfo",  { sp = c.primary,  underline = true })
      hi("DiagnosticUnderlineHint",  { sp = c.fg_muted, underline = true })

      -- which-key
      hi("WhichKey",          { fg = c.primary })
      hi("WhichKeyDesc",      { fg = c.fg })
      hi("WhichKeyGroup",     { fg = c.secondary, bold = true })
      hi("WhichKeySeparator", { fg = c.fg_muted })
      hi("WhichKeyNormal",    { fg = c.fg,       bg = c.bg_dark })
      hi("WhichKeyBorder",    { fg = c.outline,  bg = c.bg_dark })
      hi("WhichKeyTitle",     { fg = c.tertiary, bold = true })
      hi("WhichKeyIcon",      { fg = c.primary })
    '';

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

    ".config/satty/config.toml".text = ''
      [general]
      copy-command = "wl-copy"
      early-exit = true
      save-after-copy = true
    '';

  };
}
