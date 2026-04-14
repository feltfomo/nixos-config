{ inputs, self, ... }:
let
  vars = import ./../../_config.nix;
  profilesToml = builtins.fromTOML (builtins.readFile ./../../../config/zed-profiles.toml);
  profiles = profilesToml.profile or [ ];
in
{
  perSystem =
    { pkgs, lib, ... }:
    let
      theme = import ./../../theme/_theme.nix { inherit pkgs; };

      zedPatched = pkgs.zed-editor.overrideAttrs (old: {
        patches = (old.patches or [ ]) ++ [ ./zed-devshell.patch ];
      });

      zedNormal = inputs.wrapper-modules.lib.wrapPackage {
        inherit pkgs;
        package = zedPatched;
      };

      mkProfileWrapper =
        profile:
        let
          extraPathStr = lib.concatStringsSep ":" (profile.extra_path or [ ]);
          pathExport = lib.optionalString (extraPathStr != "") "export PATH=\"${extraPathStr}:$PATH\"\n";
        in
        pkgs.writeShellScriptBin "zeditor-${profile.name}" ''
          export ZED_DEVSHELL="${profile.devshell}"
          export XDG_DATA_HOME="${vars.home}/.local/share/zed-${profile.name}"
          export ZED_DISABLE_LANGUAGE_SERVER_DOWNLOADS="1"
          ${pathExport}exec ${zedPatched}/bin/zeditor "$@"
        '';

    in
    {
      packages = {
        zedNormal = zedNormal;
      }
      // builtins.listToAttrs (
        map (p: {
          name = "zed-${p.name}";
          value = mkProfileWrapper p;
        }) profiles
      );
    };

  flake.nixosModules.zed =
    { pkgs, lib, ... }:
    let
      theme = import ./../../theme/_theme.nix { inherit pkgs; };

      sharedSettings = {
        theme = {
          mode = "dark";
          dark = "Noctalia Dark";
          light = "Rosé Pine Dawn";
        };
        ui_font_size = theme.fontSize.zedUi;
        buffer_font_size = theme.fontSize.zedBuffer;
        buffer_font_family = theme.font.name;
        vim_mode = false;
        format_on_save = "on";
        autosave = "on_focus_change";
        languages = {
          Nix = {
            language_servers = [
              "nixd"
              "!nil"
            ];
            formatter = {
              external = {
                command = "nixfmt";
                arguments = [ ];
              };
            };
          };
        };
        lsp = {
          nixd = {
            binary = {
              path = "${pkgs.nixd}/bin/nixd";
            };
          };
        };
      };

      mkProfileSettings =
        profile:
        let
          hasLsp = (profile ? lsp_binary) && profile.lsp_binary != "";
          lspOverride = lib.optionalAttrs hasLsp {
            lsp = sharedSettings.lsp // {
              rust-analyzer = {
                binary = {
                  path = profile.lsp_binary;
                  args = profile.lsp_args or [ ];
                };
              };
            };
          };
        in
        sharedSettings // lspOverride;

      profileFiles = profile: {
        files = {
          ".local/share/zed-${profile.name}/zed/settings.json" = {
            generator = lib.generators.toJSON { };
            value = mkProfileSettings profile;
          };
          ".local/share/applications/zed-${profile.name}.desktop".text = ''
            [Desktop Entry]
            Name=Zed (${profile.name})
            Exec=zeditor-${profile.name} %F
            Icon=zed
            Type=Application
            Categories=Development;TextEditor;
            MimeType=text/plain;inode/directory;
          '';
        };
      };

    in
    {
      environment.systemPackages = [
        pkgs.nixd
        self.packages.${pkgs.stdenv.hostPlatform.system}.zedNormal
      ]
      ++ map (p: self.packages.${pkgs.stdenv.hostPlatform.system}."zed-${p.name}") profiles;

      hjem.users.${vars.username} = lib.foldr lib.recursiveUpdate {
        files.".config/zed/settings.json" = {
          generator = lib.generators.toJSON { };
          value = sharedSettings;
        };

        files.".config/zed/keymap.json".text = builtins.toJSON [
          {
            context = "Editor";
            bindings = {
              "tab" = null;
              "ctrl-d" = "editor::AcceptEditPrediction";
            };
          }
        ];
      } (map profileFiles profiles);
    };
}
