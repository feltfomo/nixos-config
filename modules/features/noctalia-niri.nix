{ inputs, self, ... }:
let
  vars = import ./../_config.nix;
  base = import ./_noctalia-base.nix { inherit vars; };
in
{
  flake.nixosModules.noctaliaConfigNiri = { pkgs, lib, ... }:
  let
    settings = lib.recursiveUpdate base {
      bar = {
        barType = "floating";
        density = "default";
        frameThickness = 8;
        frameRadius = 12;
        hideOnOverview = true;
        widgets = {
          right = base.bar.widgets.right ++ [
            { id = "plugin:clipper"; }
            { id = "plugin:keybind-cheatsheet"; }
          ];
        };
      };
      general = {
        panelBackgroundOpacity = 0.93;
        translucentWidgets = false;
        panelsAttachedToBar = true;
        settingsPanelMode = "attached";
        settingsPanelSideBarCardStyle = true;
      };
      location = {
        name = "Tokyo";
      };
      wallpaper = {
        overviewEnabled = true;
        viewMode = "browse";
        monitorDirectories = [
          { directory = "${vars.home}/Wallpapers"; name = vars.monitors.primary; wallpaper = ""; }
          { directory = "${vars.home}/Wallpapers"; name = vars.monitors.secondary; wallpaper = ""; }
        ];
      };
      appLauncher = {
        enableClipboardHistory = true;
        position = "center";
      };
      dock = {
        displayMode = "exclusive";
        monitors = [ vars.monitors.primary ];
      };
      colorSchemes = {
        useWallpaperColors = false;
        predefinedScheme = "Rose Pine";
        darkMode = true;
        schedulingMode = "off";
        manualSunrise = "06:30";
        manualSunset = "18:30";
        generationMethod = "tonal-spot";
        monitorForColors = "";
      };
    };
  in
  {
    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.myNoctaliaNiri
    ];
    hjem.users.${vars.username}.files = {
      ".config-niri/noctalia/settings.json" = {
        generator = lib.generators.toJSON { };
        value = settings;
      };

      ".config-niri/noctalia/wallpapers.json" = {
        generator = lib.generators.toJSON { };
        value = {
          defaultWallpaper = "${vars.home}/Wallpapers/wallhaven-3lpv1y_2560x1440.png";
          wallpapers = {
            ${vars.monitors.primary} = "${vars.home}/Wallpapers/wallhaven-3lpv1y_2560x1440.png";
            ${vars.monitors.secondary} = "${vars.home}/Wallpapers/wallhaven-3lpv1y_2560x1440.png";
          };
        };
      };

      ".config-niri/noctalia/plugins.json" = {
        generator = lib.generators.toJSON { };
        value = {
          version = 2;
          sources = [ { enabled = true; name = "Noctalia Plugins"; url = "https://github.com/noctalia-dev/noctalia-plugins"; } ];
          states = {
            clipper = { enabled = true; sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins"; };
            keybind-cheatsheet = { enabled = true; sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins"; };
            zed-provider = { enabled = true; sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins"; };
          };
        };
      };

      ".config-niri/noctalia/plugins/keybind-cheatsheet/settings.json" = {
        generator = lib.generators.toJSON { };
        value = {
          cheatsheetData = [ ];
          detectedCompositor = "niri";
        };
      };
    };
  };

  perSystem = { pkgs, ... }: {
    packages.myNoctaliaNiri = inputs.wrapper-modules.lib.wrapPackage {
      inherit pkgs;
      package = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
      env.XDG_CONFIG_HOME = "${vars.home}/.config-niri";
    };
  };
}
