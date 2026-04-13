{ ... }:
{
  plugins.oil = {
    enable = true;
    settings = {
      default_file_explorer = true;
      delete_to_trash = true;
      view_options.show_hidden = true;
      float = {
        padding = 2;
        border = "rounded";
      };
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "-";
      action = "<cmd>Oil --float<cr>";
      options.desc = "Open oil file explorer";
    }
  ];
}
