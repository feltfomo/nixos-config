{ pkgs, inputs, ... }:
{
  environment.systemPackages = with pkgs; [
    vim
    wget
    ffmpeg
    wl-clipboard
    git
    btop
    pkgs.os-prober
  ];
}
