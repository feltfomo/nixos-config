// tools/orchestrator/src/commands/zed_profile.rs
//
// fomonix zed-profile
//
// Interactively prompts for a new Zed devshell profile and appends it
// to /etc/nixos/config/zed-profiles.toml.
// A rebuild is required after adding a profile for Nix to generate the wrapper.

use std::io::{self, Write};
use std::process::exit;

use crate::read_line;

const PROFILES_TOML: &str = "/etc/nixos/config/zed-profiles.toml";

pub fn run() {
    println!("zed-profile: create a new Zed devshell profile");
    println!();

    // ── name ─────────────────────────────────────────────────────────────────

    print!("profile name (e.g. rust, java, python): ");
    io::stdout().flush().unwrap();
    let name = read_line().trim().to_string();
    if name.is_empty() {
        eprintln!("zed-profile: name cannot be empty");
        exit(1);
    }
    if name.contains('"') || name.contains('\'') || name.contains(' ') {
        eprintln!("zed-profile: name must not contain spaces or quotes");
        exit(1);
    }

    // ── devshell ──────────────────────────────────────────────────────────────

    let default_devshell = format!("nix develop /etc/nixos#{}", name);
    print!("devshell command [{}]: ", default_devshell);
    io::stdout().flush().unwrap();
    let devshell_input = read_line().trim().to_string();
    let devshell = if devshell_input.is_empty() {
        default_devshell
    } else {
        devshell_input
    };

    // ── extra_path ────────────────────────────────────────────────────────────

    print!("extra PATH entries, space-separated (leave blank to skip): ");
    io::stdout().flush().unwrap();
    let extra_path_input = read_line().trim().to_string();
    let extra_path: Vec<String> = if extra_path_input.is_empty() {
        Vec::new()
    } else {
        extra_path_input
            .split_whitespace()
            .map(|s| s.to_string())
            .collect()
    };

    // ── lsp_binary / lsp_args ─────────────────────────────────────────────────

    print!("LSP binary override path (leave blank to skip): ");
    io::stdout().flush().unwrap();
    let lsp_binary = read_line().trim().to_string();

    let lsp_args = if !lsp_binary.is_empty() {
        print!("LSP args, space-separated (leave blank for none): ");
        io::stdout().flush().unwrap();
        let raw = read_line().trim().to_string();
        if raw.is_empty() {
            Vec::new()
        } else {
            raw.split_whitespace().map(|s| s.to_string()).collect()
        }
    } else {
        Vec::new()
    };

    // ── build toml block ──────────────────────────────────────────────────────

    let mut block = format!(
        "\n[[profile]]\nname     = \"{}\"\ndevshell = \"{}\"\n",
        name, devshell
    );

    if !extra_path.is_empty() {
        let paths = extra_path
            .iter()
            .map(|p| format!("\"{}\"", p))
            .collect::<Vec<_>>()
            .join(", ");
        block.push_str(&format!("extra_path = [{}]\n", paths));
    }

    if !lsp_binary.is_empty() {
        block.push_str(&format!("lsp_binary = \"{}\"\n", lsp_binary));
        if !lsp_args.is_empty() {
            let args = lsp_args
                .iter()
                .map(|a| format!("\"{}\"", a))
                .collect::<Vec<_>>()
                .join(", ");
            block.push_str(&format!("lsp_args   = [{}]\n", args));
        }
    }

    // ── append to file ────────────────────────────────────────────────────────

    // Create file with header comment if it doesn't exist yet
    if !std::path::Path::new(PROFILES_TOML).exists() {
        let header = "# fomonix zed profile registry\n\
            # Used by zed.nix to auto-generate wrapper binaries and desktop entries.\n\
            # Add a profile here, then rebuild for Nix to pick it up.\n\
            #\n\
            # Fields:\n\
            #   name       profile name — drives binary name (zeditor-<name>),\n\
            #              data dir (~/.local/share/zed-<name>), and desktop entry\n\
            #   devshell   shell command run in every new terminal (via ZED_DEVSHELL)\n\
            #   extra_path optional list of paths prepended to PATH in the wrapper\n\
            #   lsp_binary optional path to LSP server binary\n\
            #   lsp_args   optional args passed to lsp_binary\n";
        std::fs::write(PROFILES_TOML, header).unwrap_or_else(|e| {
            eprintln!("zed-profile: could not create {}: {}", PROFILES_TOML, e);
            exit(1);
        });
    }

    let mut file = std::fs::OpenOptions::new()
        .append(true)
        .open(PROFILES_TOML)
        .unwrap_or_else(|e| {
            eprintln!("zed-profile: could not open {}: {}", PROFILES_TOML, e);
            exit(1);
        });

    file.write_all(block.as_bytes()).unwrap_or_else(|e| {
        eprintln!("zed-profile: could not write to {}: {}", PROFILES_TOML, e);
        exit(1);
    });

    // ── done ──────────────────────────────────────────────────────────────────

    println!();
    println!("profile \"{}\" added.", name);
    println!();
    println!("fine-tune it at: {}", PROFILES_TOML);
    println!();
    println!("run `fomonix rebuild` when ready to generate the wrapper.");
}
