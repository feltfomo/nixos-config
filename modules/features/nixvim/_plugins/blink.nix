{ ... }:
{
  plugins.blink-cmp = {
    enable = true;
    settings = {
      keymap.preset = "default";
      appearance = {
        nerd_font_variant = "mono";
        use_nvim_cmp_as_default = true;
      };
      sources.default = [ "lsp" "path" "buffer" ];
      completion = {
        documentation = {
          auto_show = true;
          auto_show_delay_ms = 200;
        };
        menu = {
          border = "rounded";
          draw = {
            components.label.text.__raw = ''
              require("colorful-menu").blink_components_text
            '';
            components.label.highlight.__raw = ''
              require("colorful-menu").blink_components_highlight
            '';
          };
        };
        documentation.window.border = "rounded";
      };
      signature.enabled = true;
    };
  };

  plugins.blink-pairs.enable = true;

  plugins.colorful-menu.enable = true;
}
