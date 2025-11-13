{ config, pkgs, ... }:

{
  fonts = {
    fontconfig.enable = true;
    packages = with pkgs; [
      inter
      noto-fonts
      noto-fonts-emoji
      nerd-fonts.jetbrains-mono
    ];
  };
}