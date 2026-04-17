{ self, ... }:
let
  vars = import ./../_config.nix;
in
{
  flake.nixosModules.terminal =
    { pkgs, ... }:
    let
      nushellConfig = pkgs.runCommand "nushell-config" { nativeBuildInputs = [ pkgs.pkl ]; } ''
        mkdir -p $out
        pkl eval -m $out ${self + "/config/common/shell"}/nushell.pkl
      '';

      mprocsConfig = pkgs.runCommand "mprocs-config.yaml" { nativeBuildInputs = [ pkgs.pkl ]; } ''
        pkl eval --format yaml ${self + "/config/common/shell"}/mprocs.pkl -o $out
      '';

      zoxideInit =
        pkgs.replaceVars
          (pkgs.runCommand "zoxide.fish" { nativeBuildInputs = [ pkgs.pkl ]; } ''
            pkl eval ${self + "/config/common/shell"}/zoxide.pkl -o $out
          '')
          {
            zoxideBin = pkgs.zoxide;
          };

      fastfetchInit = pkgs.runCommand "fastfetch.fish" { nativeBuildInputs = [ pkgs.pkl ]; } ''
        pkl eval ${self + "/config/common/shell"}/fish-init.pkl -o $out
      '';

    in
    {
      environment.systemPackages = with pkgs; [
        eza
        uutils-coreutils-noprefix
        ripgrep
        fd
        bat
        zoxide
        mprocs
        fastfetch
        nushell
        carapace
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
        ".config/nushell/config.nu".source = "${nushellConfig}/config.nu";
        ".config/nushell/env.nu".source = "${nushellConfig}/env.nu";
        ".config/mprocs/mprocs.yaml".source = mprocsConfig;
        ".config/fish/conf.d/zoxide.fish".source = zoxideInit;
        ".config/fish/conf.d/fastfetch.fish".source = fastfetchInit;
      };
    };
}
