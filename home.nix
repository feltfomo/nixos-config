{
  config,
  pkgs,
  inputs,
  vars,
  ...
}:
{
  imports = [
    ./modules/home/theme.nix
    ./modules/home/shell.nix
    ./modules/home/packages.nix
    ./modules/home/dms.nix
    ./modules/home/neovim.nix
    ./modules/home/spicetify.nix
    ./modules/home/zen-browser.nix
    ./modules/home/floorp.nix
    ./modules/home/niri.nix
    ./modules/home/kitty.nix
    ./modules/home/fastfetch.nix
    ./modules/home/btop.nix
    ./modules/home/prismlauncher.nix
    ./modules/home/equibop.nix
    ./modules/home/rofi.nix
    ./modules/home/zed.nix
    ./modules/home/walker.nix
    inputs.walker.homeManagerModules.default
    inputs.noctalia-shell.homeModules.default
    inputs.dms.homeModules.dank-material-shell
    inputs.zen-browser.homeModules.twilight
  ];

  home = {
    username = vars.username;
    homeDirectory = vars.homeDirectory;
    stateVersion = "25.11";
    sessionVariables = {
      LD_LIBRARY_PATH = "/run/opengl-driver/lib:$LD_LIBRARY_PATH";
    };
  };

  programs = {
    home-manager.enable = true;
    noctalia-shell.enable = true;
  };
}
