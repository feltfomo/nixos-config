{ pkgs, inputs, ... }:

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
    rofi-wayland
    waybar
    gsettings-desktop-schemes
    dconf
    inputs.zen-browser.packages.${pkgs.system}.default
    inputs.swww.packages.${pkgs.system}.swww
  ];
}
