{ config, pkgs, ... }:
{
  home.packages = [
    (pkgs.buildFHSEnv {
      name = "prismlauncher";
      targetPkgs =
        pkgs: with pkgs; [
          prismlauncher
          # MCEF/CEF core
          nspr
          nss
          glib
          dbus
          expat
          libxkbcommon
          libxcb
          # Graphics
          libGL
          libglvnd
          mesa
          libdrm
          libgbm
          # UI toolkit
          gtk3
          atk
          at-spi2-atk
          at-spi2-core
          pango
          cairo
          cups
          # X11
          libx11
          libxcomposite
          libxdamage
          libxext
          libxfixes
          libXrandr
          libxcb
          # Audio
          alsa-lib
          libpulseaudio
          pipewire
          # Nvidia
          linuxPackages.nvidia_x11
          # Misc
          udev
          stdenv.cc.cc.lib
        ];
      runScript = "prismlauncher";
      extraInstallCommands = ''
        mkdir -p $out/share/applications $out/share/icons
        cp -r ${pkgs.prismlauncher}/share/applications $out/share/
        cp -r ${pkgs.prismlauncher}/share/icons $out/share/
      '';
    })
  ];
}
