{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    vim
    wget
    kitty
    zed-editor
    btop
    fastfetch
    neovim
    git
  ];
}
