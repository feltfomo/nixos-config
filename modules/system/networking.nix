{ config, pkgs, ... }:
{
  networking.hostName = "fomonix";
  networking.networkmanager.enable = true;
}
