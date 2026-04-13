use std::fs;
use std::path::PathBuf;

pub const CONFIG: &str = "/etc/nixos/modules/_config.nix";

#[derive(Debug, Clone)]
pub struct FomonixConfig {
    pub auto_sync: bool,
    pub auto_qs_clean: bool,
    pub default_config: String, // "" = always prompt
}

impl Default for FomonixConfig {
    fn default() -> Self {
        Self {
            auto_sync: true,
            auto_qs_clean: true,
            default_config: String::new(),
        }
    }
}

pub fn load() -> FomonixConfig {
    let content = match fs::read_to_string(CONFIG) {
        Ok(c) => c,
        Err(_) => return FomonixConfig::default(),
    };
    FomonixConfig {
        auto_sync:      read_bool(&content, "autoSync").unwrap_or(true),
        auto_qs_clean:  read_bool(&content, "autoQsClean").unwrap_or(true),
        default_config: read_string(&content, "defaultConfig").unwrap_or_default(),
    }
}

pub fn save(cfg: &FomonixConfig) {
    let content = match fs::read_to_string(CONFIG) {
        Ok(c) => c,
        Err(e) => { eprintln!("config: could not read _config.nix: {}", e); return; }
    };

    let content = set_bool(&content, "autoSync", cfg.auto_sync);
    let content = set_bool(&content, "autoQsClean", cfg.auto_qs_clean);
    let content = set_string(&content, "defaultConfig", &cfg.default_config);

    fs::write(CONFIG, content)
        .unwrap_or_else(|e| eprintln!("config: could not write _config.nix: {}", e));
}

// ── string values ─────────────────────────────────────────────────────────────

pub fn read_string(content: &str, key: &str) -> Option<String> {
    for line in content.lines() {
        let trimmed = line.trim();
        if trimmed.starts_with(key) && trimmed.contains('=') {
            if let Some(start) = trimmed.find('"') {
                if let Some(end) = trimmed[start + 1..].find('"') {
                    return Some(trimmed[start + 1..start + 1 + end].to_string());
                }
            }
        }
    }
    None
}

pub fn set_string(content: &str, key: &str, value: &str) -> String {
    if !content.lines().any(|l| l.trim().starts_with(key)) {
        return content.to_string();
    }
    content
        .lines()
        .map(|line| {
            let trimmed = line.trim();
            if trimmed.starts_with(key) && trimmed.contains('=') {
                let indent: String = line.chars().take_while(|c| c.is_whitespace()).collect();
                format!("{}{} = \"{}\";", indent, key, value)
            } else {
                line.to_string()
            }
        })
        .collect::<Vec<_>>()
        .join("\n")
}

// ── bool values ───────────────────────────────────────────────────────────────

pub fn read_bool(content: &str, key: &str) -> Option<bool> {
    for line in content.lines() {
        let trimmed = line.trim();
        if trimmed.starts_with(key) && trimmed.contains('=') {
            if trimmed.contains("true") { return Some(true); }
            if trimmed.contains("false") { return Some(false); }
        }
    }
    None
}

pub fn set_bool(content: &str, key: &str, value: bool) -> String {
    if !content.lines().any(|l| l.trim().starts_with(key)) {
        return content.to_string();
    }
    content
        .lines()
        .map(|line| {
            let trimmed = line.trim();
            if trimmed.starts_with(key) && trimmed.contains('=') {
                let indent: String = line.chars().take_while(|c| c.is_whitespace()).collect();
                format!("{}{} = {};", indent, key, value)
            } else {
                line.to_string()
            }
        })
        .collect::<Vec<_>>()
        .join("\n")
}

pub fn home_dir() -> Option<PathBuf> {
    std::env::var("HOME").ok().map(PathBuf::from)
}
