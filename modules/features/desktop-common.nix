{ ... }:
{
  # Shared desktop infrastructure for both niri and hyprland configs.
  # Both compositors are fully registered here so either can be launched
  # from SDDM on either nixosConfiguration without a rebuild.
  flake.nixosModules.desktopCommon = { pkgs, ... }: {
    # Both compositors registered — SDDM can launch either.
    # Each compositor's nixosModule (niri.nix / hyprland.nix) sets the
    # package to the wrapped variant.
    programs.niri.enable = true;
    programs.hyprland = {
      enable = true;
      package = pkgs.hyprland;
      portalPackage = pkgs.xdg-desktop-portal-hyprland;
    };

    # Audio
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
    security.rtkit.enable = true;

    # Security / session
    security.polkit.enable = true;

    # Display manager
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };

    # Common Wayland env vars (compositor-specific ones stay in their module).
    # QT_QPA_PLATFORMTHEME is intentionally omitted — owned by qt.nix.
    environment.sessionVariables = {
      GDK_BACKEND   = "wayland,x11,*";
      QT_QPA_PLATFORM = "wayland;xcb";
      SDL_VIDEODRIVER = "wayland";
      MOZ_ENABLE_WAYLAND = "1";
      ELECTRON_OZONE_PLATFORM_HINT = "auto";

    };

    # Common packages available under both compositors
    environment.systemPackages = with pkgs; [
      firefox
      brave
      xwayland-satellite
    ];
  };
}
