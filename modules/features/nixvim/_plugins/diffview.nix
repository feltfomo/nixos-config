{ ... }:
{
  plugins.diffview = {
    enable = true;
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>gD";
      action = "<cmd>DiffviewOpen<cr>";
      options.desc = "Diffview open";
    }
    {
      mode = "n";
      key = "<leader>gH";
      action = "<cmd>DiffviewFileHistory %<cr>";
      options.desc = "File history (current file)";
    }
    {
      mode = "n";
      key = "<leader>gX";
      action = "<cmd>DiffviewClose<cr>";
      options.desc = "Diffview close";
    }
  ];
}
