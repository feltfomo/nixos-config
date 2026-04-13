use std::process::{Command, exit};

pub fn run() {
    println!("collecting garbage...");
    let status = Command::new("nix-collect-garbage")
        .arg("-d")
        .status()
        .unwrap_or_else(|e| { eprintln!("failed to run nix-collect-garbage: {}", e); exit(1); });
    if !status.success() { exit(status.code().unwrap_or(1)); }
}
