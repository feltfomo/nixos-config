{ ... }:
{
  flake.nixosModules.packages =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        git
        nushell
        socat
        grimblast
        satty
        wl-clipboard
        nixfmt
        stylua
        jq
      ];
    };
}
