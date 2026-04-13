{ stdenv
, lib
, fetchurl
, unzip
, autoPatchelfHook
, glib
}:
let
  mkPlugin = name: updateId: hash: stdenv.mkDerivation {
    inherit name;
    src = fetchurl {
      url = "https://plugins.jetbrains.com/plugin/download?rel=true&updateId=${updateId}";
      name = "${name}.zip";
      inherit hash;
    };
    nativeBuildInputs = [ unzip ];
    dontConfigure = true;
    dontBuild = true;
    installPhase = ''
      unzip $src -d $out
    '';
  };

  catppuccin  = mkPlugin "catppuccin"    "964697"  "sha256-6kF7cTiz/rxwg6T/U2mpM2AXfqNjIqhnfu5lXm9Abfk=";
  minecraftDev = mkPlugin "minecraft-dev" "1012596" "sha256-SCW0gCcg4eGA20Nv2GgDuHWAxqSMMYtjXXKsR1Wlx1A=";
  ideaVim     = mkPlugin "ideavim"       "1009921" "sha256-Ou0cJ9gnL/zDfCnvPVXRubNGxC3w/pjG0RR5so9iMSg=";

  plugins = [ catppuccin minecraftDev ideaVim ];
in
ide: stdenv.mkDerivation {
  pname = ide.pname + "-with-plugins";
  version = ide.version;
  src = ide;
  dontInstall = true;
  dontStrip = true;
  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [ glib ];
  inherit (ide) meta;
  buildPhase = ''
    cp -r ${ide} $out
    chmod +w -R $out
    rm -f $out/idea-community-${ide.version}/plugins/plugin-classpath.txt
    for plugin in ${lib.concatStringsSep " " (map (p: "${p}") plugins)}; do
      ln -s "$plugin" -t $out/idea-community-${ide.version}/plugins/
    done
    for exe in $out/idea-community-${ide.version}/bin/*; do
      if [ -x "$exe" ] && ( file "$exe" | grep -q 'text' ); then
        substituteInPlace "$exe" --replace-quiet '${ide}' $out
      fi
    done
  '';
}
