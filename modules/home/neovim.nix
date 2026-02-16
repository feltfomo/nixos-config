{ config, pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    # LazyVim dependencies
    extraPackages = with pkgs; [
      # LSP servers
      lua-language-server
      nil # Nix LSP

      # Build tools
      gcc
      gnumake
      unzip

      # CLI tools LazyVim uses
      ripgrep
      fd
      lazygit
    ];
  };

  # LazyVim config
  xdg.configFile."nvim" = {
    source = pkgs.fetchFromGitHub {
      owner = "LazyVim";
      repo = "starter";
      rev = "main";
      hash = "sha256-QrpnlDD4r1X4C8PqBhQ+S3ar5C+qDrU1Jm/lPqyMIFM=";
    };
    recursive = true;
  };
}
