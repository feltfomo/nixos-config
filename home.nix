{ pkgs, config, inputs, ... }:
let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};

  # --- Glassify theme (sanoojes) ---
  glassifySrc = pkgs.fetchFromGitHub {
    owner  = "sanoojes";
    repo   = "spicetify-glassify";
    rev    = "main";
    sha256 = "sha256-6O2ZjI87Yr9cqUcEzUXWXv1XxOmOjx0IYBfpg3rlw18=";   # build once, copy the printed "got: sha256-..." here, rebuild
  };
  # If the theme lives under a subfolder (e.g. "/Glassify"), change to:
  # glassifyDir = glassifySrc + "/Glassify";
  glassifyDir = glassifySrc;

  # --- NPV Ambience extension ---
  npvAmbience = {
    name = "npvAmbience.js";
    src = (pkgs.fetchFromGitHub {
      owner  = "ohitstom";
      repo   = "spicetify-extensions";
      rev    = "main";
      sha256 = "sha256-x/xmOoSsr2zQ12ZpM4hDIs/ryvCusj8LShTLoH9KMq8=";
    }) + "/npvAmbience";
  };
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
  ];

  home.sessionVariables = { GTK_THEME = "Adwaita-dark"; };

  xdg.configFile."kitty".source  = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dots/kitty";
  xdg.configFile."rofi".source   = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dots/rofi";
  xdg.configFile."hypr".source   = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dots/hypr";
  xdg.configFile."waybar".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dots/waybar";

  gtk = {
    enable = true;
    theme = { name = "Adwaita-dark"; package = pkgs.catppuccin-gtk; };
    iconTheme = { name = "Papirus-Dark"; package = pkgs.papirus-icon-theme; };
    cursorTheme = { name = "Bibata-Modern-Ice"; package = pkgs.bibata-cursors; };
    gtk3.extraConfig = { gtk-application-prefer-dark-theme = 1; };
    gtk4.extraConfig = { gtk-application-prefer-dark-theme = 1; };
  };

  dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";

  qt = {
    enable = true;
    platformTheme.name = "kvantum";
    style = { name = "kvantum"; package = pkgs.libsForQt5.qtstyleplugin-kvantum; };
  };

  programs.spicetify = {
    enable = true;

    # === Glassify theme ===
    theme = {
      name = "Glassify";
      src  = glassifyDir;

      # Defaults recommended by spicetify-nix docs
      injectCss       = true;
      injectThemeJs   = true;
      replaceColors   = true;
      homeConfig      = true;
      overwriteAssets = false;
      additionalCss   = "";
    };

    # If Glassify provides multiple color schemes, set one here, e.g.:
    # colorScheme = "dark";

    enabledCustomApps = with spicePkgs.apps; [ marketplace ];

    enabledExtensions =
      (with spicePkgs.extensions; [ hidePodcasts ]) ++ [
        npvAmbience
      ];
  };
}
