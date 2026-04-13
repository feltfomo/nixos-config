{ ... }:
{
  plugins.noice = {
    enable = true;
    settings = {
      notify.enabled = true;
      messages.enabled = true;
      lsp = {
        override = {
          "vim.lsp.util.convert_input_to_markdown_lines" = true;
          "vim.lsp.util.stylize_markdown" = true;
          "cmp.entry.get_documentation" = true;
        };
        progress.enabled = true;
        hover.enabled = true;
        signature.enabled = true;
      };
      routes = [
        {
          filter = {
            event = "msg_show";
            find = "written";
          };
          view = "notify";
        }
        {
          filter = {
            event = "msg_show";
            find = "Pattern not found";
          };
          opts.skip = true;
        }
      ];
      presets = {
        bottom_search = true;
        command_palette = true;
        long_message_to_split = true;
        inc_rename = false;
      };
    };
  };
}
