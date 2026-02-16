# WARP.md
This file provides guidance to WARP (warp.dev) when working with this repository.

## Project
**fomonix** — Personal NixOS flake for a single host (`fomonix`) with integrated
Home Manager for user `zynth`. Uses niri (with blur patch) as the compositor and
Catppuccin Mocha as the system-wide theme.

---

## Commands
```bash
# Rebuild and switch (primary workflow)
sudo nixos-rebuild switch --flake /etc/nixos#fomonix

# Dry-run before applying ANY changes — always do this first
sudo nixos-rebuild dry-run --flake /etc/nixos#fomonix

# Check flake for evaluation errors
nix flake check /etc/nixos

# Format a nix file
nixfmt <file.nix>

# Update all flake inputs
nix flake update /etc/nixos

# Update a single input
nix flake update <input-name> /etc/nixos

# Prefetch a URL for overlays (e.g. warp-terminal)
nix-prefetch-url --unpack --print-path "<url>"
nix hash convert --to sri sha256:<base32-hash>

# Garbage collect old generations
sudo nix-collect-garbage -d

# Enter Java dev shell
nix develop /etc/nixos#java

# Stage and commit after each successful rebuild
sudo git -C /etc/nixos add -A
sudo git -C /etc/nixos commit -m "refactor: <description of change>"
```

---

## Agent Rules

### Before making any changes
- Always run `sudo nixos-rebuild dry-run --flake /etc/nixos#fomonix` first and show the output to the user before proceeding.
- Never edit `hardware-configuration.nix` — it is auto-generated.
- Never change `system.stateVersion` or `home.stateVersion`.
- Always run `nixfmt` on any `.nix` file you create or modify.
- Validate with `nix flake check` after edits, before rebuilding.

### Style conventions
- Use 2-space indentation throughout.
- Prefer `{ ... }:` module signatures with only the args actually used.
- Keep `flake.nix` clean — no inline NixOS config blocks. Move overrides, cache settings, and program configs into modules.
- One concern per file. If a module is doing more than one thing, split it.
- Group `home.packages` by category with comments, as already established.

### Module locations
| Concern | Location |
|---|---|
| System-level NixOS modules | `modules/system/` |
| Home Manager modules | `modules/home/` |
| Dev shells | `modules/dev/` |
| Niri KDL configs | `niri/` |
| Package overlays | `modules/system/overlays.nix` |
| User-facing variables | `modules/system/variables.nix` |

### Refactor goals (priority order)
1. Extract the niri package override out of `flake.nix` into `modules/system/programs.nix`.
2. Extract the walker binary cache block out of `flake.nix` into `modules/system/nix-settings.nix`.
3. Extract the home-manager inline config block out of `flake.nix` into `modules/system/home-manager.nix`.
4. Move `users.users.zynth`, locale, and timezone out of `configuration.nix` into `modules/system/user.nix`.
5. Move `programs.silentSDDM` out of `configuration.nix` into `modules/system/sddm.nix`.
6. Create `modules/system/variables.nix` as the single source of truth for user settings.
7. Consolidate `zen-browser.nix` and `floorp.nix` into `modules/home/browsers.nix`.

### What NOT to change without asking
- The niri blur patch (`inputs.niri-blur`) and its `cargoHash = null` + `importCargoLock` pattern — intentional and fragile.
- Spicetify config.
- The `LD_LIBRARY_PATH` session variable in `home.nix` — required for OpenGL.
- Anything under `niri/` — KDL configs are managed manually.
- The `dms` and `noctalia-shell` module imports.

### Git workflow
- After each successful `nixos-rebuild switch`, stage and commit immediately.
- Use `sudo git -C /etc/nixos add -A` then `sudo git -C /etc/nixos commit -m "refactor: <what changed>"`.
- One commit per refactor goal — do not batch multiple goals into one commit.
- Never commit if the rebuild failed or dry-run showed errors.

---

## Architecture Overview
```
/etc/nixos
├── flake.nix                  # Inputs, outputs, devShells — keep lean
├── configuration.nix          # System entry point
├── home.nix                   # Home Manager entry point
├── hardware-configuration.nix # DO NOT EDIT
├── modules/
│   ├── system/
│   │   ├── variables.nix      # Single source of truth for settings
│   │   ├── overlays.nix       # Package overrides
│   │   ├── user.nix           # User definition + locale + timezone
│   │   ├── sddm.nix           # silentSDDM config
│   │   ├── nix-settings.nix   # Nix experimental features + caches
│   │   ├── home-manager.nix   # HM system-level config
│   │   ├── boot.nix
│   │   ├── nvidia.nix
│   │   ├── networking.nix
│   │   ├── audio.nix
│   │   ├── packages.nix
│   │   ├── portals.nix
│   │   ├── performance.nix
│   │   ├── programs.nix
│   │   ├── fonts.nix
│   │   └── thunar.nix
│   ├── home/
│   │   ├── browsers.nix       # zen-browser + floorp
│   │   └── ...
│   └── dev/
│       └── java.nix
└── niri/
```

---

## Theming
Catppuccin Mocha applied system-wide via `modules/home/theme.nix`. Do not override colors inline — route everything through `theme.nix`.

---

## Known Quirks
- `warp-terminal` in `overlays.nix` uses the latest Arch `.pkg.tar.zst`. Hash must be updated manually with `nix-prefetch-url` when Warp releases a new version.
- niri `cargoHash = null` + `importCargoLock` is intentional — do not replace with a fixed hash.
- `allowUnfree = true` is required for `warp-terminal`, `obsidian`, `code-cursor`, and nvidia drivers.