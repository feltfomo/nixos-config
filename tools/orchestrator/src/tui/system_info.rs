use std::process::Command;

pub struct SystemInfo {
    pub hostname:    String,
    pub kernel:      String,
    pub channel:     String,
    pub current_gen: String,
    pub flake_rev:   String,
    pub cpu:         String,
    pub ram:         String,
    pub gpu:         String,
    pub disk:        String,
    pub uptime:      String,
}

impl SystemInfo {
    pub fn gather() -> Self {
        Self {
            hostname:    gather_hostname(),
            kernel:      gather_kernel(),
            channel:     gather_channel(),
            current_gen: gather_current_gen(),
            flake_rev:   gather_flake_rev(),
            cpu:         gather_cpu(),
            ram:         gather_ram(),
            gpu:         gather_gpu(),
            disk:        gather_disk(),
            uptime:      gather_uptime(),
        }
    }
}

fn gather_hostname() -> String {
    std::fs::read_to_string("/etc/hostname")
        .map(|s| s.trim().to_string())
        .unwrap_or_else(|_| run_cmd("hostname", &[]).unwrap_or_else(|| "unknown".to_string()))
}

fn gather_kernel() -> String {
    run_cmd("uname", &["-r"]).unwrap_or_else(|| "?".to_string())
}

fn gather_channel() -> String {
    let flake = std::fs::read_to_string("/etc/nixos/flake.nix").unwrap_or_default();
    if flake.contains("nixos-unstable") {
        "unstable".to_string()
    } else {
        // Try to find a stable version tag like nixos-24.11
        for line in flake.lines() {
            if let Some(idx) = line.find("nixos-2") {
                let tag: String = line[idx..].chars().take_while(|c| c.is_alphanumeric() || *c == '-' || *c == '.').collect();
                if tag.len() > 6 {
                    return tag;
                }
            }
        }
        "stable".to_string()
    }
}

fn gather_current_gen() -> String {
    let output = match Command::new("sudo")
        .args(["-n", "nix-env", "--list-generations", "-p", "/nix/var/nix/profiles/system"])
        .output()
    {
        Ok(o) if o.status.success() => o,
        _ => return "?".to_string(),
    };

    let stdout = String::from_utf8_lossy(&output.stdout);
    for line in stdout.lines() {
        if line.contains("(current)") {
            if let Some(id) = line.split_whitespace().next() {
                return format!("#{}", id);
            }
        }
    }
    "?".to_string()
}

fn gather_flake_rev() -> String {
    run_cmd("git", &["-C", "/etc/nixos", "rev-parse", "--short", "HEAD"])
        .unwrap_or_else(|| "none".to_string())
}

fn gather_cpu() -> String {
    let cpuinfo = std::fs::read_to_string("/proc/cpuinfo").unwrap_or_default();
    for line in cpuinfo.lines() {
        if line.starts_with("model name") {
            if let Some(val) = line.splitn(2, ':').nth(1) {
                return clean_cpu(val.trim());
            }
        }
    }
    "?".to_string()
}

fn clean_cpu(raw: &str) -> String {
    let cleaned = raw
        .replace("(R)", "")
        .replace("(TM)", "")
        .replace("(tm)", "")
        .replace("CPU", "")
        .replace("Processor", "");

    // Collapse multiple spaces
    let mut result = String::new();
    let mut last_space = false;
    for c in cleaned.chars() {
        if c == ' ' {
            if !last_space { result.push(' '); }
            last_space = true;
        } else {
            result.push(c);
            last_space = false;
        }
    }

    // Strip @ clock speed
    if let Some(idx) = result.find('@') {
        result.truncate(idx);
    }

    result.trim().to_string()
}

fn gather_ram() -> String {
    let meminfo = std::fs::read_to_string("/proc/meminfo").unwrap_or_default();
    let mut total_kb = 0u64;
    let mut available_kb = 0u64;

    for line in meminfo.lines() {
        if line.starts_with("MemTotal:") {
            total_kb = parse_kb(line);
        } else if line.starts_with("MemAvailable:") {
            available_kb = parse_kb(line);
        }
    }

    if total_kb == 0 {
        return "?".to_string();
    }

    let used_kb = total_kb.saturating_sub(available_kb);
    format!("{} / {} GiB", kb_to_gib(used_kb), kb_to_gib(total_kb))
}

fn parse_kb(line: &str) -> u64 {
    line.split_whitespace().nth(1).and_then(|s| s.parse().ok()).unwrap_or(0)
}

fn kb_to_gib(kb: u64) -> String {
    format!("{:.1}", kb as f64 / 1_048_576.0)
}

fn gather_gpu() -> String {
    let out = match run_cmd("lspci", &[]) {
        Some(o) => o,
        None => return "?".to_string(),
    };

    for line in out.lines() {
        let lower = line.to_ascii_lowercase();
        if lower.contains("vga") || lower.contains("3d controller") || lower.contains("display controller") {
            // lspci format: "01:00.0 VGA compatible controller: NVIDIA ... [GeForce RTX 3080] (rev a1)"
            if let Some(after_class) = line.splitn(2, ':').nth(1).and_then(|s| s.splitn(2, ':').nth(1)) {
                return clean_gpu(after_class.trim());
            }
        }
    }
    "?".to_string()
}

fn clean_gpu(raw: &str) -> String {
    let mut s = raw.to_string();
    // Strip revision
    if let Some(idx) = s.find(" [rev") { s.truncate(idx); }
    if let Some(idx) = s.find(" (rev") { s.truncate(idx); }
    // Prefer the bracketed short name if present e.g. "[GeForce RTX 3080]"
    if let (Some(open), Some(close)) = (s.find('['), s.rfind(']')) {
        let inner = s[open + 1..close].trim().to_string();
        if !inner.is_empty() {
            return inner;
        }
    }
    s.trim().to_string()
}

fn gather_disk() -> String {
    let output = match Command::new("df")
        .args(["-BG", "--output=used,size", "/"])
        .output()
    {
        Ok(o) if o.status.success() => o,
        _ => return "?".to_string(),
    };

    let stdout = String::from_utf8_lossy(&output.stdout);
    if let Some(line) = stdout.lines().nth(1) {
        let mut parts = line.split_whitespace();
        let used  = parts.next().unwrap_or("?").trim_end_matches('G');
        let total = parts.next().unwrap_or("?").trim_end_matches('G');
        return format!("{} / {} GiB", used, total);
    }
    "?".to_string()
}

fn gather_uptime() -> String {
    let raw = std::fs::read_to_string("/proc/uptime").unwrap_or_default();
    let secs = raw.split_whitespace()
        .next()
        .and_then(|s| s.parse::<f64>().ok())
        .unwrap_or(0.0) as u64;

    let days  = secs / 86400;
    let hours = (secs % 86400) / 3600;
    let mins  = (secs % 3600) / 60;

    if days > 0 {
        format!("{}d {}h {}m", days, hours, mins)
    } else if hours > 0 {
        format!("{}h {}m", hours, mins)
    } else {
        format!("{}m", mins)
    }
}

fn run_cmd(cmd: &str, args: &[&str]) -> Option<String> {
    let output = Command::new(cmd).args(args).output().ok()?;
    if output.status.success() {
        Some(String::from_utf8_lossy(&output.stdout).trim().to_string())
    } else {
        None
    }
}
