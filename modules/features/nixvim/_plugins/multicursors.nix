{ ... }:
{
  plugins.multicursors = {
    enable = true;
    settings = {
      hint_config = {
        position = "bottom";
      };
    };
  };

  keymaps = [
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>mc";
      action = "<cmd>MCstart<cr>";
      options.desc = "Multi-cursor start";
    }
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>mw";
      action = "<cmd>MCvisual<cr>";
      options.desc = "Multi-cursor visual";
    }
    {
      mode = "n";
      key = "<leader>mC";
      action = "<cmd>MCclear<cr>";
      options.desc = "Multi-cursor clear";
    }
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>mp";
      action = "<cmd>MCpattern<cr>";
      options.desc = "Multi-cursor pattern";
    }
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>mu";
      action = "<cmd>MCunderCursor<cr>";
      options.desc = "Multi-cursor under cursor";
    }
  ];
}
