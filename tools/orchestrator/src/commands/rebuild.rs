use std::io::{self, Write};
use std::process::{Command, exit};
use crate::config::FomonixConfig;

pub const FLAKE: &str = "/etc/nixos";

pub fn run(dry_run: bool, cfg: &FomonixConfig) {
    if cfg.auto_sync {
        println!("syncing before rebuild...");
        crate::commands::sync::run();
        println!();
    }

    // CLI always prompts — default_config is TUI-only
    let config = prompt_config();

    let action = if dry_run { "dry-activate" } else { "switch" };
    println!();
    println!("rebuilding {} ({}){}", config, action, if dry_run { " — dry run" } else { "" });

    let status = Command::new("sudo")
        .args(["nixos-rebuild", action, "--flake", &format!("{}#{}", FLAKE, config)])
        .status()
        .unwrap_or_else(|e| { eprintln!("failed to run nixos-rebuild: {}", e); exit(1); });

    if !status.success() {
        exit(status.code().unwrap_or(1));
    }

    if cfg.auto_qs_clean {
        println!();
        println!("clearing noctalia-qs cache...");
        crate::commands::qs_clean::run();
    }
}

pub fn prompt_config() -> String {
    println!("select configuration:");
    println!("  [1] fomonix         (niri)");
    println!("  [2] fomonixHyprland (hyprland)");
    println!("  [3] cancel");
    print!("> ");
    io::stdout().flush().unwrap();
    match crate::read_line().trim().to_string().as_str() {
        "1" => "fomonix".to_string(),
        "2" => "fomonixHyprland".to_string(),
        "3" => { println!("cancelled."); exit(0); }
        other => { eprintln!("unknown choice: {}", other); exit(1); }
    }
}
