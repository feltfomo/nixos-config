use std::fs;
use crate::config::home_dir;

pub fn run() {
    let cache_dir = match home_dir().map(|h| h.join(".cache/noctalia-qs")) {
        Some(p) => p,
        None => { eprintln!("qs-clean: could not determine home directory"); return; }
    };

    if !cache_dir.exists() {
        println!("qs-clean: ~/.cache/noctalia-qs not found, nothing to do");
        return;
    }

    fs::remove_dir_all(&cache_dir)
        .expect("qs-clean: failed to remove ~/.cache/noctalia-qs");

    println!("qs-clean: cleared ~/.cache/noctalia-qs");
}

pub fn run_silent(output: &mut Vec<String>) {
    let cache_dir = match home_dir().map(|h| h.join(".cache/noctalia-qs")) {
        Some(p) => p,
        None => {
            output.push("qs-clean: could not determine home dir".to_string());
            return;
        }
    };

    if !cache_dir.exists() {
        output.push("qs-clean: nothing to do".to_string());
        return;
    }

    if let Err(e) = std::fs::remove_dir_all(&cache_dir) {
        output.push(format!("qs-clean: failed: {}", e));
        return;
    }

    output.push("qs-clean: cleared ~/.cache/noctalia-qs".to_string());
}
