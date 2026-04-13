{ ... }:
{
  plugins.aerial = {
    enable = true;
    settings = {
      backends = [
        "lsp"
        "treesitter"
        "markdown"
        "asciidoc"
        "man"
      ];
      layout = {
        max_width = [
          40
          0.2
        ];
        width = null;
        min_width = 20;
        win_opts = { };
        default_direction = "prefer_right";
        placement = "window";
        preserve_equality = false;
      };
      attach_mode = "window";
      close_automatic_events = [ "unsupported" ];
      # Highlight the current symbol on cursor move
      highlight_on_hover = true;
      highlight_on_jump = 300;
      autojump = false;
      # Show tree guides
      show_guides = true;
      guides = {
        mid_item = "├─";
        last_item = "└─";
        nested_top = "│ ";
        whitespace = "  ";
      };
      # Sync folds with aerial tree
      manage_folds = false;
      link_folds_to_tree = false;
      link_tree_to_folds = true;
      # Close aerial when selecting a symbol
      close_on_select = false;
      # Filter which symbol kinds to show
      filter_kind = [
        "Class"
        "Constructor"
        "Enum"
        "Function"
        "Interface"
        "Module"
        "Method"
        "Struct"
      ];
      icons = { };
      nerd_font = "auto";
      # Treesitter integration
      treesitter = {
        experimental_selection_range = false;
      };
      # Telescope extension is registered automatically when both are enabled
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>ao";
      action = "<cmd>AerialToggle<cr>";
      options.desc = "Aerial toggle";
    }
    {
      mode = "n";
      key = "<leader>an";
      action.__raw = "function() require('aerial').nav_toggle() end";
      options.desc = "Aerial nav (miller column)";
    }
    # Jump through symbols without opening the panel
    {
      mode = "n";
      key = "]a";
      action.__raw = "function() require('aerial').next() end";
      options.desc = "Next aerial symbol";
    }
    {
      mode = "n";
      key = "[a";
      action.__raw = "function() require('aerial').prev() end";
      options.desc = "Prev aerial symbol";
    }
    # Telescope picker for symbols (uses aerial backend)
    {
      mode = "n";
      key = "<leader>fA";
      action = "<cmd>Telescope aerial<cr>";
      options.desc = "Find symbols (aerial)";
    }
  ];
}
