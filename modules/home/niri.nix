{
  config,
  pkgs,
  lib,
  ...
}:

let
  # Path to the KDL source files living next to this module
  niriBin = "${pkgs.niri}/bin/niri";
  kdlDir = ../../niri;
in
{
  xdg.configFile = {
    "niri/config.kdl".source = "${kdlDir}/config.kdl";
    "niri/decoration.kdl".source = "${kdlDir}/decoration.kdl";
    "niri/input.kdl".source = "${kdlDir}/input.kdl";
    "niri/layout.kdl".source = "${kdlDir}/layout.kdl";
    "niri/overview-wallpaper.kdl".source = "${kdlDir}/overview-wallpaper.kdl";
    "niri/window-rule.kdl".source = "${kdlDir}/window-rule.kdl";
    # "niri/colors.kdl".source = "${kdlDir}/colors.kdl";
  };

  home.packages = with pkgs; [
    swww
  ];
}
