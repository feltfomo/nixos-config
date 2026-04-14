{ ... }:
let
  vars = import ./../_config.nix;
in
{
  flake.nixosModules.obs =
    { pkgs, ... }:
    {
      programs.obs-studio = {
        enable = true;
        plugins = with pkgs.obs-studio-plugins; [
          obs-pipewire-audio-capture
          wlrobs
        ];
      };

      hjem.users.${vars.username}.files = {
        ".local/share/applications/com.obsproject.Studio.desktop".source =
          pkgs.runCommand "obs-desktop-file" { }
            ''
              cp ${pkgs.obs-studio}/share/applications/com.obsproject.Studio.desktop $out
              substituteInPlace $out --replace "Icon=com.obsproject.Studio" "Icon=obs"
            '';
      };
    };
}
