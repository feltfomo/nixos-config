{ ... }:
{
  flake.nixosModules.packages =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        git
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
