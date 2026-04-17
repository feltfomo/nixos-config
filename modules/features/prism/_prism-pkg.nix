{
  stdenv,
  fetchFromGitHub,
  cmake,
  cmark,
  extra-cmake-modules,
  gamemode,
  jdk17,
  kdePackages,
  libarchive,
  ninja,
  qrencode,
  stripJavaArchivesHook,
  tomlplusplus,
  vulkan-headers,
  zlib,
  lib,
  msaClientID ? null,
}:
let
  version = "11.0.2";
  libnbtplusplus = fetchFromGitHub {
    owner = "PrismLauncher";
    repo = "libnbtplusplus";
    rev = "3538933614059f0f44388a2b16f3db25ce42285b";
    hash = "sha256-6/8clF2yNhfonV16cfIkxVIzuB9i9ThxoLMxAo/fDuY=";
  };
in
stdenv.mkDerivation {
  pname = "prismlauncher-custom-unwrapped";
  inherit version;
  src = fetchFromGitHub {
    owner = "PrismLauncher";
    repo = "PrismLauncher";
    tag = version;
    hash = "sha256-GvAfrZxQSlBnCJ59nvK87jDTVo60D8n25K42SokE1q8=";
  };
  postUnpack = ''
    rm -rf source/libraries/libnbtplusplus
    ln -s ${libnbtplusplus} source/libraries/libnbtplusplus
  '';
  nativeBuildInputs = [
    cmake
    ninja
    extra-cmake-modules
    jdk17
    stripJavaArchivesHook
  ];
  buildInputs = [
    cmark
    kdePackages.qtbase
    kdePackages.qtnetworkauth
    libarchive
    qrencode
    tomlplusplus
    vulkan-headers
    zlib
    gamemode
  ];
  cmakeFlags = [
    (lib.cmakeFeature "Launcher_BUILD_PLATFORM" "fomonix")
  ]
  ++ lib.optionals (msaClientID != null) [
    (lib.cmakeFeature "Launcher_MSA_CLIENT_ID" (toString msaClientID))
  ];
  doCheck = true;
  dontWrapQtApps = true;
  meta = {
    description = "Custom Prism Launcher build for fomonix (unwrapped)";
    homepage = "https://prismlauncher.org";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    mainProgram = "prismlauncher";
  };
}
