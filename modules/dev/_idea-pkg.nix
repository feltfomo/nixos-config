{ stdenv
, lib
, fetchurl
, autoPatchelfHook
, makeWrapper
, makeDesktopItem
, copyDesktopItems
, writeText
, jetbrains
, zlib
, libsecret
, libnotify
, udev
, fontconfig
, libGL
, libx11
, coreutils
, gnugrep
, which
, git
, maven
, glibcLocales
}:
let
  version = "2025.2.6.1";
  jdk = jetbrains.jdk;

  ideaProperties = writeText "idea.properties" ''
    idea.no.jre.check=true
    idea.jdk.home=${jdk.home}
  '';
in
stdenv.mkDerivation {
  pname = "idea-community";
  inherit version;

  src = fetchurl {
    url = "https://download.jetbrains.com/idea/ideaIC-${version}.tar.gz";
    hash = "sha256-RJJPeYY7NoZOerWMH21bKZWr6f5i4YFUtsuETUYIXkE=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
    copyDesktopItems
  ];

  buildInputs = [
    stdenv.cc.cc
    fontconfig
    libGL
    libx11
    zlib
  ];

  preFixup = ''
    addAutoPatchelfSearchPath $out/idea-community-${version}
  '';

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/idea-community-${version} $out/bin \
             $out/share/icons/hicolor/scalable/apps \
             $out/share/icons/hicolor/128x128/apps

    cp -a . $out/idea-community-${version}/

    # Swap bundled JBR for pkgs.jetbrains.jdk so libjvm.so is found
    rm -rf $out/idea-community-${version}/jbr
    ln -s ${jdk.home} $out/idea-community-${version}/jbr

    # Icons
    ln -s $out/idea-community-${version}/bin/idea.svg \
          $out/share/icons/hicolor/scalable/apps/idea-community.svg
    ln -s $out/idea-community-${version}/bin/idea.png \
          $out/share/icons/hicolor/128x128/apps/idea-community.png

    wrapProgram $out/idea-community-${version}/bin/idea \
      --prefix PATH : ${lib.makeBinPath [ jdk coreutils gnugrep which git ]} \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [
        libsecret
        libnotify
        udev
        zlib
      ]} \
      --set-default JAVA_HOME "${jdk.home}" \
      --set-default JDK_HOME "${jdk.home}" \
      --set-default IDEA_JDK "${jdk.home}" \
      --set-default JETBRAINS_CLIENT_JDK "${jdk.home}" \
      --set-default GRADLE_JVM "${jdk.home}" \
      --set IDEA_PROPERTIES "${ideaProperties}" \
      --set-default LOCALE_ARCHIVE "${glibcLocales}/lib/locale/locale-archive" \
      --set M2_HOME "${maven}/maven" \
      --set M2 "${maven}/maven/bin"

    ln -s $out/idea-community-${version}/bin/idea $out/bin/idea-community

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "idea-community";
      exec = "idea-community %f";
      icon = "idea-community";
      comment = "Intelligent Java and Kotlin IDE";
      desktopName = "IntelliJ IDEA Community";
      genericName = "Java IDE";
      categories = [ "Development" "IDE" ];
      startupWMClass = "jetbrains-idea-ce";
    })
  ];

  meta = {
    description = "Free Java, Kotlin, Groovy and Scala IDE from JetBrains";
    homepage = "https://www.jetbrains.com/idea/";
    platforms = lib.platforms.linux;
    mainProgram = "idea-community";
  };
}
