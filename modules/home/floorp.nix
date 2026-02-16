{ config, pkgs, ... }:
let
  floorpProfile = ".floorp/kyastyyk.default";
  paneruRepo = pkgs.fetchFromGitHub {
    owner = "TheBigWazz";
    repo = "Paneru";
    rev = "ba8da16fbede075c4f0882ee7834026569fd201f";
    hash = "sha256-WhasK8/vbt/xaVD6xUqqfj1GzuGlbtcU92xAcYiaaFM=";
  };
  paneruPatched = pkgs.runCommand "paneru-patched" { } ''
    cp -r ${paneruRepo} $out
    chmod -R u+w $out
    echo '/* paneruContent disabled */' > $out/Paneru/modules/paneruContent.css
  '';
in
{
  home.file."${floorpProfile}/chrome" = {
    source = paneruPatched;
    recursive = true;
  };
}
