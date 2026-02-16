{ config, pkgs, ... }:

{
  fonts.fontconfig.enable = true;

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    dejavu_fonts
    liberation_ttf
    inter
    noto-fonts-color-emoji

    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.iosevka
  ];

  fonts.fontconfig.defaultFonts = {
    serif = [ "Noto Serif" ];
    sansSerif = [ "Inter" "Noto Sans" ];
    monospace = [ "JetBrainsMono Nerd Font" "DejaVu Sans Mono" ];
    emoji = [ "Noto Color Emoji" ];
  };
}
