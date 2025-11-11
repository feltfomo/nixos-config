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
      package = pkgs.catppuccin-gtk.override {
        accents = [ "blue" ];
        size = "standard";
        variant = "mocha";
      };
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

  # Neovim configuration
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    extraPackages = with pkgs; [
      # LSP servers
      lua-language-server
      nil # Nix LSP
      nodePackages.typescript-language-server

      # Tools that lazy.nvim plugins might need
      gcc
      gnumake
      unzip
      git
      ripgrep
      fd
      nodejs
      tree-sitter
    ];
  };

  xdg.configFile = {
    # GTK4 theme symlinks
    "gtk-4.0/assets".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/assets";
    "gtk-4.0/gtk.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk.css";
    "gtk-4.0/gtk-dark.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk-dark.css";
    # Your existing configs
    "kitty".source  = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dots/kitty";
    "rofi".source   = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dots/rofi";
    "hypr".source   = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dots/hypr";
    "waybar".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dots/waybar";
    # Neovim config
    "nvim".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dots/nvim";
  };
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
