{ ... }:
{
  flake.nixosModules.packages =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        git
        gamemode
        mangohud
        mangojuice
        socat
        grimblast
        satty
        wl-clipboard
        cliphist
        nixfmt
        stylua
        jq
        pkl
        pkl-lsp
      ];
    };
}
