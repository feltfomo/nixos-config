use std::fs;
use std::io::{self, Write};
use crate::config::{self, home_dir, CONFIG};

pub fn run() {
    sync_zen_profile();
}

pub fn run_silent(output: &mut Vec<String>) {
    // same logic as run() but push to output instead of println!
    output.push("sync: zen profile check skipped in TUI mode".to_string());
}

fn sync_zen_profile() {
    let zen_dir = match home_dir().map(|h| h.join(".config/zen")) {
        Some(p) => p,
        None => { eprintln!("sync: could not determine home directory"); return; }
    };

    if !zen_dir.exists() {
        println!("sync: ~/.config/zen not found, skipping zen profile sync");
        return;
    }

    let profiles: Vec<String> = fs::read_dir(&zen_dir)
        .expect("sync: could not read ~/.config/zen")
        .filter_map(|e| e.ok())
        .filter(|e| e.path().is_dir())
        .map(|e| e.file_name().to_string_lossy().to_string())
        .filter(|name| {
            name.contains('.')
                && !name.starts_with('.')
                && name != "firefox-mpris"
                && name != "Profile Groups"
        })
        .collect();

    if profiles.is_empty() {
        println!("sync: no zen profiles found, skipping");
        return;
    }

    let selected = if profiles.len() == 1 {
        profiles[0].clone()
    } else {
        println!("multiple zen profiles found, pick one:");
        for (i, p) in profiles.iter().enumerate() {
            println!("  [{}] {}", i + 1, p);
        }
        print!("> ");
        io::stdout().flush().unwrap();
        let choice = crate::read_line();
        let idx: usize = match choice.trim().parse::<usize>() {
            Ok(n) if n >= 1 && n <= profiles.len() => n - 1,
            _ => { eprintln!("sync: invalid selection"); return; }
        };
        profiles[idx].clone()
    };

    let content = fs::read_to_string(CONFIG)
        .expect("sync: could not read _config.nix");

    let current = config::read_string(&content, "zenProfile");

    if current.as_deref() == Some(selected.as_str()) {
        println!("sync: zenProfile already set to \"{}\"", selected);
        return;
    }

    let updated = config::set_string(&content, "zenProfile", &selected);
    fs::write(CONFIG, updated).expect("sync: could not write _config.nix");

    match current {
        Some(old) => println!("sync: zenProfile updated \"{}\" → \"{}\"", old, selected),
        None      => println!("sync: zenProfile set to \"{}\"", selected),
    }
}
