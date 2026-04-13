{ inputs, self, ... }:
let
  vars = import ./../_config.nix;
  base = import ./_noctalia-base.nix { inherit vars; };
in
{
  flake.nixosModules.noctaliaConfigHyprland = { pkgs, lib, ... }:
  let
    settings = lib.recursiveUpdate base {
      bar = {
        barType = "framed";
        density = "comfortable";
        frameThickness = 24;
        frameRadius = 24;
        hideOnOverview = false;
        showCapsule = false;
      };
      general = {
        allowPasswordWithFprintd = false;
        clockStyle = "custom";
        clockFormat = "hh\\nmm";
        passwordChars = false;
        lockScreenMonitors = [ ];
        lockScreenBlur = 0;
        lockScreenTint = 0;
      };
      ui = {
        panelBackgroundOpacity = 0.55;
        translucentWidgets = true;
      };
      location = {
        name = "";
        autoLocate = false;
        weatherTaliaMascotAlways = false;
      };
      wallpaper = {
        overviewEnabled = false;
        viewMode = "single";
        linkLightAndDarkWallpapers = true;
      };
      appLauncher = {
        enableClipboardHistory = false;
        position = "bottom_center";
      };
      dock = {
        displayMode = "auto_hide";
        monitors = [ ];
      };
      colorSchemes = {
        useWallpaperColors = true;
        predefinedScheme = "Noctalia (default)";
        darkMode = true;
        schedulingMode = "off";
        manualSunrise = "06:30";
        manualSunset = "18:30";
        generationMethod = "tonal-spot";
        monitorForColors = "";
        syncGsettings = true;
      };
      templates = {
        enableUserTheming = true;
        activeTemplates = [
          { id = "gtk"; enabled = true; }
          { id = "qt"; enabled = true; }
        ];
      };
    };
  in
  {
    imports = [
      ./_noctalia-hyprland/templates.nix
      ./_noctalia-hyprland/plugins.nix
      ./_noctalia-hyprland/submap-osd.nix
    ];

    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.myNoctaliaHyprland
    ];

    hjem.users.${vars.username}.files = {
      ".config-hyprland/noctalia/settings.json" = {
        generator = lib.generators.toJSON { };
        value = settings;
      };
    };
  };

  perSystem = { pkgs, ... }: {
    packages.myNoctaliaHyprland = inputs.wrapper-modules.lib.wrapPackage {
      inherit pkgs;
      package = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
      env.XDG_CONFIG_HOME = "${vars.home}/.config-hyprland";
    };
  };
}
