use clap::{Parser, Subcommand};
use std::io::{self, Write};
use std::process::{Command, exit};

mod config;
mod commands;
mod tui;

#[derive(Parser)]
#[command(name = "fomonix")]
#[command(about = "fomonix orchestrator — nix system manager")]
struct Cli {
    #[command(subcommand)]
    command: Option<Commands>,
}

#[derive(Subcommand)]
enum Commands {
    /// Sync system state then rebuild
    Rebuild {
        #[arg(long)]
        dry_run: bool,
    },
    /// Sync _config.nix with detected system state
    Sync,
    /// Update flake inputs and optionally rebuild
    Update,
    /// Collect garbage
    Gc,
    /// Prefetch a URL and convert hash to SRI
    Prefetch {
        url: String,
    },
    /// Clear the noctalia-qs QML cache
    QsClean,
    /// Update a managed package to its latest GitHub release
    UpdatePkg {
        /// Package name (e.g. "mcsr")
        pkg: String,
    },
    /// Add a new Zed devshell profile
    ZedProfile,
}

fn main() {
    let cli = Cli::parse();
    match cli.command {
        None => {
            // No subcommand — launch TUI
            let mut app = tui::app::App::new();
            if let Err(e) = app.run() {
                eprintln!("tui error: {}", e);
                exit(1);
            }
        }
        Some(Commands::Rebuild { dry_run }) => {
            let cfg = config::load();
            commands::rebuild::run(dry_run, &cfg);
        }
        Some(Commands::Sync)       => commands::sync::run(),
        Some(Commands::Update)     => cmd_update(),
        Some(Commands::Gc)         => commands::gc::run(),
        Some(Commands::QsClean)    => commands::qs_clean::run(),
        Some(Commands::Prefetch { url }) => cmd_prefetch(&url),
        Some(Commands::UpdatePkg { pkg }) => commands::update_pkg::run(&pkg),
        Some(Commands::ZedProfile) => commands::zed_profile::run(),
    }
}

// ── update ───────────────────────────────────────────────────────────────────

fn cmd_update() {
    println!("updating flake inputs...");
    run_status("nix", &["flake", "update", commands::rebuild::FLAKE]);

    println!();
    print!("rebuild now? [y/N] ");
    io::stdout().flush().unwrap();
    let answer = read_line();
    if answer.trim().eq_ignore_ascii_case("y") {
        let cfg = config::load();
        commands::rebuild::run(false, &cfg);
    } else {
        println!("skipping rebuild.");
    }
}

// ── prefetch ─────────────────────────────────────────────────────────────────

fn cmd_prefetch(url: &str) {
    println!("fetching {}...", url);

    let output = Command::new("nix-prefetch-url")
        .args(["--type", "sha256", "--name", "plugin.zip", url])
        .output()
        .expect("prefetch: failed to run nix-prefetch-url");

    if !output.status.success() {
        eprintln!("prefetch: nix-prefetch-url failed");
        eprintln!("{}", String::from_utf8_lossy(&output.stderr));
        exit(1);
    }

    let raw_hash = String::from_utf8_lossy(&output.stdout).trim().to_string();

    let sri_output = Command::new("nix")
        .args(["hash", "to-sri", "--type", "sha256", &raw_hash])
        .output()
        .expect("prefetch: failed to run nix hash convert");

    if !sri_output.status.success() {
        eprintln!("prefetch: nix hash convert failed");
        eprintln!("{}", String::from_utf8_lossy(&sri_output.stderr));
        exit(1);
    }

    let sri_hash = String::from_utf8_lossy(&sri_output.stdout).trim().to_string();

    println!();
    println!("raw sha256:  {}", raw_hash);
    println!("SRI:         {}", sri_hash);
}

// ── helpers ───────────────────────────────────────────────────────────────────

pub fn read_line() -> String {
    let mut input = String::new();
    io::stdin().read_line(&mut input).unwrap();
    input
}

fn run_status(cmd: &str, args: &[&str]) {
    let status = Command::new(cmd)
        .args(args)
        .status()
        .unwrap_or_else(|e| {
            eprintln!("failed to run {}: {}", cmd, e);
            exit(1);
        });
    if !status.success() {
        exit(status.code().unwrap_or(1));
    }
}
