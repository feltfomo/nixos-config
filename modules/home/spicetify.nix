{ pkgs, inputs, ... }:
let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};
in
{
  programs.spicetify = {
    enable = true;
    enabledCustomApps = with spicePkgs.apps; [ marketplace ];
    enabledExtensions = (with spicePkgs.extensions; [ hidePodcasts ]) ++ [
      {
        name = "npvAmbience.js";
        src = (pkgs.fetchFromGitHub {
          owner = "ohitstom"; 
          repo = "spicetify-extensions"; 
          rev = "main";
          sha256 = "sha256-GVlfji0n9LX1xi7l4gG6Tboo4o554auYplM8CW08tFQ=";
        }) + "/npvAmbience";
      }
    ];
  };
}