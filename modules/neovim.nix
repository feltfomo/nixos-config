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
}