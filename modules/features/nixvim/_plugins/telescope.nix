{ ... }:
{
  plugins.web-devicons.enable = true;

  plugins.telescope = {
    enable = true;
    settings = {
      defaults = {
        layout_strategy = "horizontal";
        layout_config.prompt_position = "top";
        sorting_strategy = "ascending";
      };
    };
    keymaps = {
      "<leader><leader>" = { action = "find_files"; options.desc = "Find files"; };
      "<leader>fg" = { action = "live_grep"; options.desc = "Live grep"; };
      "<leader>fb" = { action = "buffers"; options.desc = "Buffers"; };
      "<leader>fh" = { action = "help_tags"; options.desc = "Help tags"; };
      "<leader>fr" = { action = "oldfiles"; options.desc = "Recent files"; };
    };
  };
}
