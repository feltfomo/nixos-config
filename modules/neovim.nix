# modules/neovim.nix
{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    extraPackages = with pkgs; [
      lua-language-server
      nil
      nodePackages.typescript-language-server
      gcc
      gnumake
      unzip
      git
      ripgrep
      fd
      nodejs
      tree-sitter
    ];
  };

  home.file.".config/nvim/lua/plugins/presence.lua".text = ''
    return {
      "andweeb/presence.nvim",
      event = "VeryLazy",
      opts = {
        neovim_image_text = "Neovim",
        main_image = "neovim",
        editing_text = "Editing %s",
        file_explorer_text = "Browsing %s",
        git_commit_text = "Committing changes",
        workspace_text = "Working on %s",
        line_number_text = "Line %s/%s",
      },
    }
  '';
}
