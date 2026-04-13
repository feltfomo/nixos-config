{ pkgs, ... }:
{
  # vim-repeat makes . work with surround actions
  extraPlugins = [ pkgs.vimPlugins.vim-repeat ];

  plugins.vim-surround = {
    enable = true;
  };
}
