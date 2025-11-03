{ pkgs, config, inputs, ... }:
let
  # Packaged things exported by spicetify-nix (extensions, apps, themes)
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};

  # NPV Ambience (vendored from upstream repo)
  npvAmbience = {
    name = "npvAmbience.js";
    src = (pkgs.fetchFromGitHub {
      owner  = "ohitstom";
      repo   = "spicetify-extensions";
      rev    = "main";
      sha256 = "sha256-x/xmOoSsr2zQ12ZpM4hDIs/ryvCusj8LShTLoH9KMq8=";
    }) + "/npvAmbience";
  };

  # Local Beautiful Lyrics (from your flake)
  beautifulLyrics = {
    name = "beautiful-lyrics.mjs";
    src  = builtins.path {
      path = ./spice/beautiful-lyrics.mjs;  # relative path inside the flake
      name = "beautiful-lyrics.mjs";
    };
  };
in
{
  # Import spicetify-nix’s Home Manager module
  imports = [ inputs.spicetify-nix.homeManagerModules.default ];

  home.username = "zynth";
  home.homeDirectory = "/home/zynth";
  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    catppuccin-gtk
    papirus-icon-theme
    bibata-cursors
  ];

  home.sessionVariables = {
    GTK_THEME = "Adwaita-dark";
  };

  # Link configs
  xdg.configFile."kitty".source  = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dots/kitty";
  xdg.configFile."rofi".source   = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dots/rofi";
  xdg.configFile."hypr".source   = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dots/hypr";
  xdg.configFile."waybar".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dots/waybar";

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.catppuccin-gtk;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    cursorTheme = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
    };
    gtk3.extraConfig = { gtk-application-prefer-dark-theme = 1; };
    gtk4.extraConfig = { gtk-application-prefer-dark-theme = 1; };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = { color-scheme = "prefer-dark"; };
  };

  qt = {
    enable = true;
    platformTheme.name = "kvantum";
    style = {
      name = "kvantum";
      package = pkgs.libsForQt5.qtstyleplugin-kvantum;
    };
  };

  # Spicetify configuration
  programs.spicetify = {
    enable = true;

    # Optional Marketplace page (browse-only)
    enabledCustomApps = with spicePkgs.apps; [ marketplace ];

    # Extensions: built-in + vendored + local
    enabledExtensions =
      (with spicePkgs.extensions; [ hidePodcasts ]) ++ [
        npvAmbience
        beautifulLyrics
      ];
  };
}
