{ self, ... }:
{
  flake.nixosModules.minecraft = { pkgs, ... }: {
    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.ideaMinecraft
    ];
    hjem.users.feltfomo.files = {
      ".gradle/gradle.properties".text = ''
        org.gradle.java.home=${pkgs.jetbrains.jdk.home}
        org.gradle.daemon=true
        org.gradle.parallel=true
        org.gradle.caching=true
      '';
      ".config/JetBrains/IdeaIC2025.2/idea.properties".text = ''
        idea.no.jre.check=true
        idea.jdk.home=${pkgs.jetbrains.jdk.home}
      '';
      ".config/JetBrains/IdeaIC2025.2/options/gradle.xml".text = ''
        <?xml version="1.0" encoding="UTF-8"?>
        <application>
          <component name="GradleSettings">
            <option name="linkedExternalProjectsSettings">
              <GradleProjectSettings>
                <option name="gradleJvm" value="${pkgs.jetbrains.jdk.home}" />
              </GradleProjectSettings>
            </option>
          </component>
        </application>
      '';
    };
  };

  perSystem = { pkgs, lib, ... }:
  let
    nativeLibs = lib.makeLibraryPath (with pkgs; [
      libGL
      libGLU
      mesa
      vulkan-loader
      vulkan-validation-layers
      openal
      libpulseaudio
      udev
      wayland
      libxkbcommon
      libx11
      libxext
      libxrender
      libxrandr
      libxcursor
      libxi
      libxxf86vm
    ]);

    ideaBase = pkgs.callPackage ./_idea-pkg.nix {};
    withPlugins = pkgs.callPackage ./_idea-plugins.nix {};

  in {
    packages.ideaMinecraft = withPlugins ideaBase;

    devShells.minecraft = pkgs.mkShell {
      name = "minecraft-dev";
      packages = [
        pkgs.jetbrains.jdk
        pkgs.gradle
        pkgs.maven
        pkgs.kotlin
        pkgs.kotlin-language-server
        pkgs.git
        pkgs.pciutils
        pkgs.glxinfo
        pkgs.vulkan-tools
      ];
      shellHook = ''
        export JAVA_HOME="${pkgs.jetbrains.jdk.home}"
        export LD_LIBRARY_PATH="${nativeLibs}''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
        export LWJGL_LIBRARY_PATH="${nativeLibs}"
        export VK_ICD_FILENAMES="/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.json"
        export _JAVA_AWT_WM_NONREPARENTING=1

        echo ""
        echo "  minecraft dev shell"
        echo "  java:   $(java -version 2>&1 | head -1)"
        echo "  gradle: $(gradle --version | grep Gradle)"
        echo ""
      '';
    };
  };
}
