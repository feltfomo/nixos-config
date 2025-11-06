{ pkgs, config, inputs, ... }:
let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};
in
{
  imports = [ inputs.spicetify-nix.homeManagerModules.default ];

  home.username = "zynth";
  home.homeDirectory = "/home/zynth";
  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    catppuccin-gtk
    papirus-icon-theme
    bibata-cursor-theme
    qt6ct
  ];

  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-Mocha-Standard-Blue-Dark";
      package = pkgs.catppuccin-gtk;
    };
    iconTheme = { name = "Papirus-Dark"; package = pkgs.papirus-icon-theme; };
    cursorTheme = { name = "Bibata-Modern-Ice"; package = pkgs.bibata-cursor-theme; };
    gtk3.extraConfig = { gtk-application-prefer-dark-theme = 1; };
    gtk4.extraConfig = { gtk-application-prefer-dark-theme = 1; };
  };

  home.pointerCursor = {
    package = pkgs.bibata-cursor-theme;
    name = "Bibata-Modern-Ice";
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  home.sessionVariables = {
    GTK_THEME        = "Catppuccin-Mocha-Standard-Blue-Dark";
    GTK_ICON_THEME   = "Papirus-Dark";
    GTK_CURSOR_THEME = "Bibata-Modern-Ice";
    XCURSOR_THEME    = "Bibata-Modern-Ice";
    XCURSOR_SIZE     = "24";
    MOZ_ENABLE_WAYLAND = "1";
  };

  qt = {
    enable = true;
    platformTheme.name = "kvantum";
    style = {
      name = "kvantum";
      package = pkgs.qt6Packages.qtstyleplugin-kvantum;
    };
  };

  dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";

  xdg.configFile."kitty".source  = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dots/kitty";
  xdg.configFile."rofi".source   = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dots/rofi";
  xdg.configFile."hypr".source   = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dots/hypr";
  xdg.configFile."waybar".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dots/waybar";

  programs.spicetify = {
    enable = true;
    enabledCustomApps = with spicePkgs.apps; [ marketplace ];
    enabledExtensions = (with spicePkgs.extensions; [ hidePodcasts ]) ++ [
      {
        name = "npvAmbience.js";
        src = (pkgs.fetchFromGitHub {
          owner = "ohitstom"; repo = "spicetify-extensions"; rev = "main";
          sha256 = "sha256-x/xmOoSsr2zQ12ZpM4hDIs/ryvCusj8LShTLoH9KMq8=";
        }) + "/npvAmbience";
      }
    ];
  };
}
