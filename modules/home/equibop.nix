{ config, pkgs, ... }:
let
  equibop = pkgs.stdenv.mkDerivation {
    pname = "equibop";
    version = "3.1.8";
    src = pkgs.fetchzip {
      url = "https://github.com/Equicord/Equibop/releases/download/v3.1.8/equibop-3.1.8.tar.gz";
      hash = "sha256-epEs4A5DfxTkFGQsihnmQ9ebVN5GtvZG1xFa82jn4BQ=";
      stripRoot = false;
    };
    nativeBuildInputs = [ pkgs.autoPatchelfHook ];
    buildInputs = with pkgs; [
      libGL
      libdrm
      mesa
      wayland
      expat
      libxkbcommon
      linuxPackages.nvidia_x11
      glib
      nspr
      nss
      atk
      at-spi2-atk
      cups
      cairo
      gtk3
      pango
      libxcomposite
      libxdamage
      libxfixes
      alsa-lib
      at-spi2-core
      stdenv.cc.cc.lib
      libglvnd
      pipewire
      libpulseaudio
    ];
    autoPatchelfIgnoreMissingDeps = true;
    installPhase = ''
      mkdir -p $out/bin $out/share/equibop
      cp -r $src/. $out/share/equibop/
      cat > $out/bin/equibop << EOF
      #!/bin/sh
      export LD_LIBRARY_PATH=${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.libglvnd}/lib:${pkgs.linuxPackages.nvidia_x11}/lib:${pkgs.pipewire}/lib:${pkgs.libpulseaudio}/lib:\$LD_LIBRARY_PATH
      exec $out/share/equibop/equibop-3.1.8/equibop --enable-wayland-ime --ozone-platform-hint=auto "\$@"
      EOF
      chmod +x $out/bin/equibop
    '';
  };
in
{
  home.packages = [ equibop ];
}
