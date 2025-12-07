{ pkgs, inputs, ... }:
{
  environment.systemPackages = with pkgs; [
    vim
    wget
    ffmpeg
    wl-clipboard
    copyq
    git
    btop
    pkgs.os-prober
  ];
}
