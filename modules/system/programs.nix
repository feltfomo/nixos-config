{
  config,
  pkgs,
  inputs,
  ...
}:
let
  hyprexpo = pkgs.hyprlandPlugins.hyprexpo;
in
{
  environment.systemPackages = with pkgs; [
    papirus-icon-theme
    hyprexpo
  ];
  environment.etc."hypr/plugins/libhyprexpo.so".source = "${hyprexpo}/lib/libhyprexpo.so";
  programs = {
    # Niri compositor with blur patch
    niri = {
      enable = true;
      package = pkgs.niri.overrideAttrs (old: {
        src = inputs.niri-blur;
        cargoHash = null;
        cargoDeps = pkgs.rustPlatform.importCargoLock {
          lockFile = "${inputs.niri-blur}/Cargo.lock";
          allowBuiltinFetchGit = true;
        };
        doCheck = false;
        doInstallCheck = false;
      });
    };
    hyprland.enable = true;
    gamemode.enable = true;
    zsh.enable = true;
    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        glib
        zlib
        libglvnd
        mesa
        libdrm
        wayland
        stdenv.cc.cc.lib
        linuxPackages.nvidia_x11
        pipewire
        libpulseaudio
        nspr
        nss
        dbus
      ];
    };
  };
}
