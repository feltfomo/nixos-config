{ inputs, self, ... }:
let
  vars = import ./../_config.nix;
in
{
  flake.nixosModules.dmsConfigNiri =
    { pkgs, lib, ... }:
    let
      # --- pkl pipelines ---

      dmsSettings = pkgs.runCommand "dms-niri-settings.json" { nativeBuildInputs = [ pkgs.pkl ]; } ''
        pkl eval --format json ${self + "/config/niri/dms/settings"}/main.pkl -o $out
      '';

      theming = pkgs.runCommand "dms-theming" { nativeBuildInputs = [ pkgs.pkl ]; } ''
        mkdir -p $out
        pkl eval -m $out ${self + "/config/niri/dms/theming"}/main.pkl
      '';

      pluginSettings = pkgs.runCommand "dms-plugin-settings.json" { nativeBuildInputs = [ pkgs.pkl ]; } ''
        pkl eval --format json ${self + "/config/niri/dms/plugins"}/main.pkl -o $out
      '';

      # --- plugin fetch helpers ---

      plugins = [
        {
          id = "clipboardPlus";
          repo = "Dadangdut33/dms-plugins";
          rev = "846aff653e9492f2907790e1017f723206ea568b";
          hash = "sha256-8tjUOdk4WzluGS9GB/oZstrpM5WNdhu41TiTCwflrIw=";
          path = "ClipboardPlus";
          repodir = "7c0d8f010141a5dc";
        }
      ];

      mkPlugin =
        p:
        let
          src = pkgs.fetchFromGitHub {
            owner = builtins.head (builtins.match "([^/]+)/.*" p.repo);
            repo = builtins.head (builtins.match "[^/]+/(.*)" p.repo);
            rev = p.rev;
            hash = p.hash;
          };
        in
        pkgs.runCommand "dms-plugin-${p.id}" { } ''
          cp -r ${src}/${p.path} $out
        '';

      pluginFiles = lib.listToAttrs (
        lib.concatMap (p: [
          {
            name = ".config/DankMaterialShell/plugins/${p.id}";
            value = {
              source = mkPlugin p;
            };
          }
          {
            name = ".config/DankMaterialShell/${p.id}.meta";
            value.text = ''
              repo=https://github.com/${p.repo}
              path=${p.path}
              repodir=${p.repodir}
            '';
          }
        ]) plugins
      );
    in
    {
      imports = [
        inputs.dms.nixosModules.default
      ];

      programs.dank-material-shell = {
        enable = true;
        package = inputs.dms.packages.${pkgs.stdenv.hostPlatform.system}.default;
        enableDynamicTheming = true;
        enableAudioWavelength = true;
        enableClipboardPaste = true;
        enableCalendarEvents = true;
        enableSystemMonitoring = true;
        enableVPN = true;
      };

      environment.systemPackages = with pkgs; [
        khal
        glib
      ];

      hjem.users.${vars.username}.files = {
        ".config/DankMaterialShell/settings.json".source          = dmsSettings;
        ".config/DankMaterialShell/plugin_settings.json".source   = pluginSettings;
        ".config/matugen/config.toml".source                      = "${theming}/config.toml";
        ".config/matugen/templates/kitty-dms-colors.conf".source  = "${theming}/kitty-dms-colors.conf";
        ".config/matugen/templates/niri-dms-colors.kdl".source    = "${theming}/niri-dms-colors.kdl";
        ".config/matugen/templates/nvim-dms-colors.lua".source    = "${theming}/nvim-dms-colors.lua";
        ".config/matugen/templates/lualine-dms-colors.lua".source = "${theming}/lualine-dms-colors.lua";
        ".config/matugen/templates/foot-dms-colors.ini".source    = "${theming}/foot-dms-colors.ini";
        ".config/matugen/templates/zed-theme.json".source         = "${theming}/zed-theme.json";
        ".config/matugen/templates/satty.css".source              = "${theming}/satty.css";
        ".config/matugen/templates/ghostty-colors".source         = "${theming}/ghostty-colors";
      }
      // pluginFiles;
    };
}
