{ stdenv
, fetchurl
, autoPatchelfHook
, makeWrapper
, alsa-lib
, at-spi2-atk
, at-spi2-core
, cups
, dbus
, expat
, glib
, libdrm
, libnotify
, libuuid
, libxkbcommon
, mesa
, nspr
, nss
, libx11
, libxcomposite
, libxcursor
, libxdamage
, libxext
, libxfixes
, libxi
, libxrandr
, libxrender
, libxscrnsaver
, libxtst
, libxcb
, gtk3
, pango
, cairo
, gdk-pixbuf
, atk
, gsettings-desktop-schemas
, libglvnd
, pipewire
, lib
}:
let
  version = "3.1.9";
in
stdenv.mkDerivation {
  pname = "equibop";
  inherit version;
  src = fetchurl {
    url = "https://github.com/Equicord/Equibop/releases/download/v${version}/equibop-${version}.tar.gz";
    hash = "sha256-40SUavhqhcYLxOfMnvv8OsP+58QWNLzhdEu0GmwLRp8=";
  };
  nativeBuildInputs = [ autoPatchelfHook makeWrapper ];
  buildInputs = [
    alsa-lib at-spi2-atk at-spi2-core cups dbus expat glib
    libdrm libnotify libuuid libxkbcommon mesa nspr nss
    libx11 libxcomposite libxcursor libxdamage
    libxext libxfixes libxi libxrandr
    libxrender libxscrnsaver libxtst libxcb
    gtk3 pango cairo gdk-pixbuf atk
    gsettings-desktop-schemas libglvnd
    pipewire
    stdenv.cc.cc.lib
  ];
  sourceRoot = "equibop-${version}";
  dontConfigure = true;
  dontBuild = true;
  preFixup = ''
    addAutoPatchelfSearchPath $out/opt/equibop
  '';
  installPhase = ''
    runHook preInstall
    mkdir -p $out/opt/equibop $out/bin \
             $out/share/applications \
             $out/share/icons/hicolor/256x256/apps
    cp -r . $out/opt/equibop/
    install -Dm644 ${./assets/equibop.png} \
      $out/share/icons/hicolor/256x256/apps/equibop.png
    makeWrapper $out/opt/equibop/equibop $out/bin/equibop \
      --add-flags "--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations,WebRTCPipeWireCapturer" \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [
        stdenv.cc.cc.lib
        mesa
        libglvnd
        gsettings-desktop-schemas
        pipewire
      ]} \
      --prefix XDG_DATA_DIRS : ${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}
    cat > $out/share/applications/equibop.desktop << EOF
    [Desktop Entry]
    Name=Equibop
    Exec=$out/bin/equibop %U
    Icon=equibop
    Type=Application
    Categories=Network;InstantMessaging;
    MimeType=x-scheme-handler/discord;
    StartupWMClass=Equibop
    EOF
    runHook postInstall
  '';
  meta = {
    description = "Custom Discord client with Equicord";
    homepage = "https://github.com/Equicord/Equibop";
    platforms = lib.platforms.linux;
    mainProgram = "equibop";
  };
}
