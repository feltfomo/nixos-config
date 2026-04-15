{ inputs, self, ... }:
let
  vars = import ./../_config.nix;
in
{
  flake.nixosModules.dmsConfigNiri =
    { pkgs, lib, ... }:
    let
      pluginFiles = import ./_dms-plugins.nix { inherit pkgs lib; };
    in
    {
      imports = [
        inputs.dms.nixosModules.default
        ./_dms-niri/templates.nix
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

      hjem.users.${vars.username}.files =
        let
          dmsSettings =
            pkgs.runCommand "dms-niri-settings.json"
              {
                nativeBuildInputs = [ pkgs.pkl ];
              }
              ''
                pkl eval --format json ${self + "/config/dms/niri"}/main.pkl -o $out 
              '';
        in
        {
          ".config/DankMaterialShell/settings.json".source = dmsSettings;
        }
        // pluginFiles;
    };
}
