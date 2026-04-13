{ ... }:
{
  plugins.lazygit = {
    enable = true;
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>gg";
      action = "<cmd>LazyGit<cr>";
      options.desc = "LazyGit";
    }
    {
      mode = "n";
      key = "<leader>gf";
      action = "<cmd>LazyGitCurrentFile<cr>";
      options.desc = "LazyGit current file";
    }
    {
      mode = "n";
      key = "<leader>gl";
      action = "<cmd>LazyGitFilterCurrentFile<cr>";
      options.desc = "LazyGit file log";
    }
  ];
}
