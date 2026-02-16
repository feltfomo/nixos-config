{ config, pkgs, lib, ... }:

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
    # colors.kdl is referenced by config.kdl but you don't have a standalone one yet;
    # DMS writes dms/colors.kdl and the include for it is commented out in config.kdl,
    # so this is left out intentionally. Uncomment the line below if you add one.
    # "niri/colors.kdl".source = "${kdlDir}/colors.kdl";
  };

  # mpvpaper and swww are used in the KDL config, make sure they're available
  home.packages = with pkgs; [
    mpvpaper
    swww
  ];
}
