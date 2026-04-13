{ ... }:
let vars = import ./../_config.nix;
in {
  flake.nixosModules.terminal = { pkgs, ... }:
  let
    rosePineBatTheme = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/rose-pine/tm-theme/main/dist/rose-pine.tmTheme";
      hash = "sha256-pOvfKUxgkK7/db6ZgDbE810PBUBm0vlXCp8iF/REE+Y=";
    };
  in {
    environment.systemPackages = with pkgs; [
      eza
      uutils-coreutils-noprefix
      ripgrep
      fd
      bat
      zoxide
      mprocs
      fastfetch
    ];
    programs.fish.shellAliases = {
      ls = "eza --icons";
      lt = "eza --icons --tree";
      cat = "bat";
      find = "fd";
      grep = "rg";
      cd = "z";
      rebuild = "sudo nixos-rebuild switch --flake /etc/nixos#${vars.hostname}";
      update = "nix flake update /etc/nixos";
    };
    hjem.users.${vars.username}.files = {
      ".config/bat/themes/rose-pine.tmTheme".source = rosePineBatTheme;
      ".config/bat/config".text = ''
        --theme="rose-pine"
        --paging=auto
        --style=numbers,changes,header
      '';
      ".config/fish/conf.d/zoxide.fish".text = ''
        ${pkgs.zoxide}/bin/zoxide init fish | source
      '';
      ".config/mprocs/mprocs.yaml".text = ''
        log_dir: ~/.local/share/mprocs/logs
        hide_keymap_window: false
        mouse_scroll_speed: 3
        scrollback: 2000
      '';
    };
  };
}
