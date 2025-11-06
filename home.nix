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
    bibata-cursors
    qt6ct
  ];

  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-Mocha-Standard-Blue-Dark";
      package = pkgs.catppuccin-gtk;
    };
    iconTheme = { name = "Papirus-Dark"; package = pkgs.papirus-icon-theme; };
    cursorTheme = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
    };
    gtk3.extraConfig = { gtk-application-prefer-dark-theme = 1; };
    gtk4.extraConfig = { gtk-application-prefer-dark-theme = 1; };
  };

  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
    gtk.enable = true;
    x11.enable = true;
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
