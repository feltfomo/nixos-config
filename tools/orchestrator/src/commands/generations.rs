use std::process::{Command, Stdio};

#[derive(Debug, Clone)]
pub struct Generation {
    pub id:      u32,
    pub date:    String,
    pub current: bool,
}

pub fn list() -> Vec<Generation> {
    let output = match Command::new("nix-env")
        .args(["--list-generations", "-p", "/nix/var/nix/profiles/system"])
        .stdout(Stdio::piped())
        .stderr(Stdio::null())
        .output()
    {
        Ok(o) => o,
        Err(_) => return vec![],
    };

    String::from_utf8_lossy(&output.stdout)
        .lines()
        .filter_map(parse_generation_line)
        .collect()
}

fn parse_generation_line(line: &str) -> Option<Generation> {
    let trimmed = line.trim();
    if trimmed.is_empty() {
        return None;
    }
    // Format: "137   2026-04-09 20:34:50   (current)"
    let mut parts = trimmed.splitn(4, char::is_whitespace);
    let id: u32 = parts.next()?.trim().parse().ok()?;
    let date_part = parts.next()?.trim().to_string();
    let time_part = parts.next()?.trim().to_string();
    let rest = parts.next().unwrap_or("").trim();
    let current = rest.contains("(current)");
    Some(Generation {
        id,
        date: format!("{} {}", date_part, time_part),
        current,
    })
}
