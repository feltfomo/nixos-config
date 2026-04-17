{ self, ... }:
{
  flake.nixosModules.prism =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.prismLauncher
      ];
    };

  perSystem =
    { pkgs, ... }:
    let
      inherit (pkgs) lib;
      runtimeLibs = with pkgs; [
        (lib.getLib stdenv.cc.cc)
        glfw3-minecraft
        openal
        alsa-lib
        libjack2
        libpulseaudio
        pipewire
        libGL
        libx11
        libxcursor
        libxext
        libxrandr
        libxxf86vm
        udev
        vulkan-loader
        gamemode.lib
        libXt
        libXtst
        libXi
        libxkbcommon
        libxkbfile
      ];
      runtimePrograms = with pkgs; [
        pciutils
        xrandr
      ];
      jdks = with pkgs; [
        jdk21
        jdk17
        jdk8
      ];
    in
    {
      packages.prismLauncher =
        let
          unwrapped = pkgs.callPackage ./_prism-pkg.nix { };
        in
        pkgs.symlinkJoin {
          pname = "prismlauncher-custom";
          inherit (unwrapped) version;
          paths = [ unwrapped ];
          nativeBuildInputs = [ pkgs.kdePackages.wrapQtAppsHook ];
          buildInputs = with pkgs.kdePackages; [
            qtbase
            qtimageformats
            qtsvg
            qtwayland
          ];
          postBuild = "wrapQtAppsHook";
          qtWrapperArgs = [
            "--prefix PRISMLAUNCHER_JAVA_PATHS : ${lib.makeSearchPath "bin/java" jdks}"
            "--set LD_LIBRARY_PATH ${pkgs.addDriverRunpath.driverLink}/lib:${lib.makeLibraryPath runtimeLibs}"
            "--prefix PATH : ${lib.makeBinPath runtimePrograms}"
          ];
        };
    };
}
