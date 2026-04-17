{ inputs, self, ... }:
let
  vars = import ./../_config.nix;
in
{
  flake.nixosModules.noctaliaConfigHyprland =
    { pkgs, lib, ... }:
    let
      noctaliaSettings = pkgs.runCommand "noctalia-settings.json" { nativeBuildInputs = [ pkgs.pkl ]; } ''
        pkl eval --format json ${self + "/config/hyprland/noctalia/settings"}/main.pkl -o $out
      '';

      noctaliaPlugins = pkgs.runCommand "noctalia-plugins" { nativeBuildInputs = [ pkgs.pkl ]; } ''
        mkdir -p $out
        pkl eval -m $out ${self + "/config/hyprland/noctalia/plugins"}/main.pkl
      '';

      noctaliaTheming = pkgs.runCommand "noctalia-theming" { nativeBuildInputs = [ pkgs.pkl ]; } ''
        mkdir -p $out
        pkl eval -m $out ${self + "/config/hyprland/noctalia/theming"}/main.pkl
      '';
    in
    {
      environment.systemPackages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.myNoctalia
      ];

      hjem.users.${vars.username}.files = {
        ".config-hyprland/noctalia/settings.json".source = noctaliaSettings;
        ".config-hyprland/noctalia/plugins.json".source = "${noctaliaPlugins}/plugins.json";

        ".config-hyprland/noctalia/plugins/submap-osd/manifest.json".source =
          "${noctaliaPlugins}/submap-osd-manifest.json";
        ".config-hyprland/noctalia/plugins/submap-osd/Main.qml".source =
          "${noctaliaPlugins}/submap-osd-Main.qml";
        ".config-hyprland/noctalia/plugins/keybind-cheatsheet/settings.json".source =
          "${noctaliaPlugins}/keybind-cheatsheet-settings.json";

        ".config-hyprland/noctalia/user-templates.toml".source = "${noctaliaTheming}/user-templates.toml";
        ".config-hyprland/noctalia/templates/kitty-colors.conf".source =
          "${noctaliaTheming}/kitty-colors.conf";
        ".config-hyprland/noctalia/templates/hyprland-colors.conf".source =
          "${noctaliaTheming}/hyprland-colors.conf";
        ".config-hyprland/noctalia/templates/zed-theme.json".source = "${noctaliaTheming}/zed-theme.json";
        ".config-hyprland/noctalia/templates/satty.css".source = "${noctaliaTheming}/satty.css";
        ".config-hyprland/noctalia/templates/nvim-colors.lua".source = "${noctaliaTheming}/nvim-colors.lua";
        ".config-hyprland/noctalia/templates/lualine-colors.lua".source =
          "${noctaliaTheming}/lualine-colors.lua";
        ".config-hyprland/noctalia/templates/foot-colors.ini".source = "${noctaliaTheming}/foot-colors.ini";
        ".config-hyprland/noctalia/templates/ghostty-colors".source = "${noctaliaTheming}/ghostty-colors";
      };
    };

  perSystem =
    { pkgs, ... }:
    {
      packages.myNoctalia = inputs.wrapper-modules.lib.wrapPackage {
        inherit pkgs;
        package = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
        env.XDG_CONFIG_HOME = "${vars.home}/.config-hyprland";
      };
    };
}
