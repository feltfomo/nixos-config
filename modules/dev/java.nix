{ pkgs }:
pkgs.mkShell {
  name = "java-dev-shell";
  buildInputs = with pkgs; [
    # Java
    jetbrains.jdk
    # Build Tools
    gradle
    maven
    # Audio
    alsa-lib
    alsa-plugins
    libpulseaudio
    pipewire
    # Graphics / UI
    libGL
    libglvnd
    libxkbcommon
    libx11
    libXcursor
    libXrandr
    libXinerama
    libXext
    libXrender
    libXtst
    # Minecraft / Modding
    glfw3-minecraft
    vulkan-loader
    libdecor
    libxscrnsaver
    # Native / General
    zlib
    openal
    flite
    nspr
    nss
    # CEF dependencies
    libgbm
    glib
    atk
    at-spi2-atk
    libdrm
    expat
    libxcomposite
    libxdamage
    libxfixes
    gtk3
    pango
    cairo
    dbus
    at-spi2-core
    cups
    libxcb
    # Dev Utilities
    git
    jdt-language-server
  ];
  shellHook = ''
    export JAVA_HOME=${pkgs.jetbrains.jdk}
    export WAYLAND_DISPLAY=''${WAYLAND_DISPLAY:-wayland-1}
    export XDG_RUNTIME_DIR=''${XDG_RUNTIME_DIR:-/run/user/1000}
    export LD_LIBRARY_PATH="${
      pkgs.lib.makeLibraryPath (
        with pkgs;
        [
          jetbrains.jdk
          alsa-lib
          alsa-plugins
          libpulseaudio
          pipewire
          libGL
          libglvnd
          libxkbcommon
          libx11
          libXcursor
          libXrandr
          libXinerama
          libXext
          libXrender
          libXtst
          glfw3-minecraft
          vulkan-loader
          libdecor
          libxscrnsaver
          zlib
          openal
          flite
          nspr
          nss
          libgbm
          glib
          atk
          at-spi2-atk
          libdrm
          expat
          libxcomposite
          libxdamage
          libxfixes
          gtk3
          pango
          cairo
          dbus
          at-spi2-core
          cups
          libxcb
        ]
      )
    }:$LD_LIBRARY_PATH"
    alias mc="prismlauncher"
    echo "☕ Java Dev Shell Loaded"
  '';
}
