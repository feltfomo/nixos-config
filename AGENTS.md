# AGENTS.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Commands

```bash
# Rebuild and switch to new configuration
sudo nixos-rebuild switch --flake /etc/nixos#fomonix

# Dry-run to see what would change
sudo nixos-rebuild dry-run --flake /etc/nixos#fomonix

# Format nix files
nixfmt <file.nix>

# Garbage collect old generations
sudo nix-collect-garbage -d

# Enter Java development shell
nix develop /etc/nixos#java

# Update flake inputs
nix flake update

# Update a specific input
nix flake update <input-name>
```

## Architecture

This is a NixOS flake-based configuration for a single host (`fomonix`) with integrated home-manager for user `zynth`.

### Entry Points
- `flake.nix` - Flake definition with inputs and outputs. Defines the `fomonix` NixOS configuration and dev shells.
- `configuration.nix` - System-level NixOS configuration, imports all system modules
- `home.nix` - Home Manager configuration, imports all home modules
- `hardware-configuration.nix` - Auto-generated hardware config (do not edit)

### Module Organization
- `modules/system/` - System-level modules (boot, nvidia, networking, audio, packages, etc.)
- `modules/home/` - User-level Home Manager modules (shell, theme, applications)
- `modules/dev/` - Development shells (e.g., `java.nix` for Java/Minecraft modding)
- `niri/` - KDL configuration files for the niri window manager (linked via `modules/home/niri.nix`)

### Key Flake Inputs
- `nixpkgs` - nixos-unstable channel
- `home-manager` - User environment management
- `niri-flake` + `niri-blur` - Niri compositor with blur patches
- `zen-browser`, `spicetify-nix`, `walker` - Application-specific flakes
- `silentSDDM`, `noctalia-shell`, `dms` - Desktop/theming flakes

### Theming
System uses Catppuccin Mocha theme consistently across GTK, Qt (Kvantum), cursors, and applications.

### Nix Settings
- Flakes and nix-command are enabled
- Unfree packages are allowed
- Walker binary cache is configured
