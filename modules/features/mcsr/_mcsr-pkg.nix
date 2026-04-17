{ stdenv
, fetchurl
, makeWrapper
, jdk21
, lib
}:
let
  version = "0.8.3-beta";
in
stdenv.mkDerivation {
  pname = "mcsr-launcher";
  inherit version;

  src = fetchurl {
    url = "https://github.com/MCSRLauncher/Launcher/releases/download/${version}/MCSRLauncher.jar";
    hash = "sha256-ANTciD013nWMTrhUFuFPFmUW3sRfxtOM4xLt0BUx79w=";
  };

  dontUnpack = true;
  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jdk21 ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/mcsr-launcher $out/bin \
             $out/share/applications \
             $out/share/icons/hicolor/256x256/apps

    install -Dm644 $src $out/share/mcsr-launcher/MCSRLauncher.jar

    makeWrapper ${jdk21}/bin/java $out/bin/mcsr-launcher \
      --add-flags "-jar $out/share/mcsr-launcher/MCSRLauncher.jar" \
      --set _JAVA_AWT_WM_NONREPARENTING 1

    install -Dm644 ${./assets/mcsr.png} \
      $out/share/icons/hicolor/256x256/apps/mcsr-launcher.png

    cat > $out/share/applications/mcsr-launcher.desktop << EOF
    [Desktop Entry]
    Name=MCSR Launcher
    Comment=Minecraft Launcher for Speedrunning
    Exec=$out/bin/mcsr-launcher
    Icon=mcsr-launcher
    Type=Application
    Categories=Game;
    StartupWMClass=mcsr-launcher
    EOF

    runHook postInstall
  '';

  meta = {
    description = "Minecraft launcher tailored for MCSR speedrunning";
    homepage = "https://github.com/MCSRLauncher/Launcher";
    platforms = lib.platforms.linux;
    mainProgram = "mcsr-launcher";
  };
}
