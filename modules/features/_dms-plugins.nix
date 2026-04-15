{ pkgs, lib }:

let
  toJSON = lib.generators.toJSON { };

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

  pluginSettings = {
    clipboardPlus = {
      enabled = true;
      panelOpacityClipboard = 100;
    };
  };

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

  pluginFiles = {
    ".config/DankMaterialShell/plugin_settings.json" = {
      generator = toJSON;
      value = pluginSettings;
    };
  }
  // lib.listToAttrs (
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
pluginFiles
