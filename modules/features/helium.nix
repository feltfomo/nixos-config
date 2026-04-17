{ self, ... }:
{
  flake.nixosModules.helium =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.helium
      ];
    };

  perSystem =
    { pkgs, ... }:
    {
      packages.helium =
        let
          version = "0.10.8.1";
          pname = "helium";
        in
        pkgs.stdenv.mkDerivation {
          inherit pname version;

          src = pkgs.fetchurl {
            url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-x86_64_linux.tar.xz";
            # Run: nix-prefetch-url <url>
            # or:  nix store prefetch-file <url>
            hash = "sha256-qu0GvCbg4Eq1cHrTerOzH98KkL0FCSVQgLe+QWyH9d4=";
          };

          nativeBuildInputs = with pkgs; [
            autoPatchelfHook
            makeWrapper
            wrapGAppsHook3
          ];

          buildInputs = with pkgs; [
            alsa-lib
            at-spi2-atk
            at-spi2-core
            cairo
            cups
            dbus
            expat
            glib
            gtk3
            libdrm
            libxkbcommon
            mesa
            nspr
            nss
            pango
            udev
            xorg.libX11
            xorg.libXcomposite
            xorg.libXdamage
            xorg.libXext
            xorg.libXfixes
            xorg.libXrandr
            xorg.libxcb
          ];

          runtimeDependencies = with pkgs; [
            libGL
            vulkan-loader
            (lib.getLib stdenv.cc.cc)
          ];

          # The Qt5/Qt6 shims are optional file-picker integrations — Chromium
          # has a built-in GTK file picker that works fine without them.
          autoPatchelfIgnoreMissingDeps = [
            "libQt5Core.so.5"
            "libQt5Gui.so.5"
            "libQt5Widgets.so.5"
            "libQt6Core.so.6"
            "libQt6Gui.so.6"
            "libQt6Widgets.so.6"
          ];

          dontConfigure = true;
          dontBuild = true;

          installPhase = ''
            runHook preInstall

            mkdir -p $out/opt/helium $out/bin $out/share

            cp -r . $out/opt/helium/

            # Desktop entry + icons
            install -Dm644 $out/opt/helium/helium.desktop \
              $out/share/applications/helium.desktop

            for size in 16 32 48 64 128 256; do
              icon="$out/opt/helium/product_logo_''${size}.png"
              if [ -f "$icon" ]; then
                install -Dm644 "$icon" \
                  "$out/share/icons/hicolor/''${size}x''${size}/apps/helium.png"
              fi
            done

            # Fix desktop entry Exec path
            substituteInPlace $out/share/applications/helium.desktop \
              --replace-fail "Exec=helium" "Exec=$out/bin/helium"

            makeWrapper $out/opt/helium/helium $out/bin/helium \
              --set CHROME_WRAPPER helium \
              --add-flags "--ozone-platform-hint=auto" \
              --add-flags "--enable-wayland-ime" \
              --add-flags "--password-store=basic" \
              --suffix LD_LIBRARY_PATH : "${
                pkgs.lib.makeLibraryPath [
                  pkgs.libGL
                  pkgs.vulkan-loader
                  (pkgs.lib.getLib pkgs.stdenv.cc.cc)
                ]
              }"

            runHook postInstall
          '';

          meta = {
            description = "Private, fast, and honest web browser (Helium)";
            homepage = "https://helium.computer";
            license = pkgs.lib.licenses.gpl3;
            platforms = [ "x86_64-linux" ];
            mainProgram = "helium";
          };
        };
    };
}
