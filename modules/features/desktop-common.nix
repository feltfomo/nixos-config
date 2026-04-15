{ ... }:
{
  # Shared desktop infrastructure for both niri and hyprland configs.
  # programs.niri.enable and programs.hyprland.enable are intentionally NOT here —
  # each compositor's nixosModule enables only itself, so SDDM only shows the
  # session that was actually built for the active nixosConfiguration.
  flake.nixosModules.desktopCommon =
    { pkgs, ... }:
    {
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
        GDK_BACKEND = "wayland,x11,*";
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
