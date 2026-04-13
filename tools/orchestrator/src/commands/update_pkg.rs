// tools/orchestrator/src/commands/update_pkg.rs
//
// fomonix update-pkg <pkg>
//
// Reads the package registry from /etc/nixos/config/packages.toml, fetches
// the latest release, compares against the current version in the _pkg.nix,
// prefetches the hash if needed, and patches the file in-place.
// Adding a new package requires only editing packages.toml — no recompile.

use std::io::{self, Write};
use std::process::{Command, exit};

use serde::Deserialize;

use crate::read_line;
use crate::config;
use crate::commands::rebuild::FLAKE;

const PACKAGES_TOML: &str = "/etc/nixos/config/packages.toml";

// ── toml schema ───────────────────────────────────────────────────────────────

#[derive(Deserialize)]
struct Registry {
    #[serde(rename = "package")]
    packages: Vec<PkgEntry>,
}

#[derive(Deserialize)]
struct PkgEntry {
    name: String,
    pkg_nix: String,
    prefetch_name: String,
    source: String,

    // github fields
    repo: Option<String>,
    asset: Option<String>,
    strip_v: Option<bool>,

    // jetbrains fields
    product_code: Option<String>,
    download_url_template: Option<String>,
}

// ── entry point ───────────────────────────────────────────────────────────────

pub fn run(pkg: &str) {
    let registry = load_registry();

    let entry = registry.packages.iter().find(|e| e.name == pkg).unwrap_or_else(|| {
        let known: Vec<_> = registry.packages.iter().map(|e| e.name.as_str()).collect();
        eprintln!("update-pkg: unknown package {:?}", pkg);
        eprintln!("known packages: {}", known.join(", "));
        eprintln!("add new packages to {}", PACKAGES_TOML);
        exit(1);
    });

    println!("update-pkg: checking latest release for {}...", entry.name);

    let pkg_nix_path = format!("{}/{}", FLAKE, entry.pkg_nix);
    let current_version = read_current_version(&pkg_nix_path);

    let (latest_version, download_url) = fetch_latest(entry);

    println!("  current version: {}", current_version.as_deref().unwrap_or("unknown"));
    println!("  latest version:  {}", latest_version);

    if current_version.as_deref() == Some(latest_version.as_str()) {
        println!();
        println!("already up to date.");
        return;
    }

    println!();

    let sri = prefetch_sri(&download_url, &entry.prefetch_name);

    println!("  new hash: {}", sri);
    println!();

    patch_pkg_nix(&pkg_nix_path, &latest_version, &sri);

    println!("patched {}", entry.pkg_nix);
    println!();

    print!("rebuild now? [y/N] ");
    io::stdout().flush().unwrap();
    let answer = read_line();
    if answer.trim().eq_ignore_ascii_case("y") {
        let cfg = config::load();
        crate::commands::rebuild::run(false, &cfg);
    } else {
        println!("skipping rebuild. run `fomonix rebuild` when ready.");
    }
}

// ── registry loader ───────────────────────────────────────────────────────────

fn load_registry() -> Registry {
    let content = std::fs::read_to_string(PACKAGES_TOML).unwrap_or_else(|e| {
        eprintln!("update-pkg: could not read {}: {}", PACKAGES_TOML, e);
        exit(1);
    });

    toml::from_str(&content).unwrap_or_else(|e| {
        eprintln!("update-pkg: failed to parse {}: {}", PACKAGES_TOML, e);
        exit(1);
    })
}

// ── current version reader ────────────────────────────────────────────────────

fn read_current_version(path: &str) -> Option<String> {
    let content = std::fs::read_to_string(path).ok()?;
    for line in content.lines() {
        let trimmed = line.trim_start();
        if trimmed.starts_with("version = \"") && trimmed.ends_with("\";") {
            let inner = trimmed
                .trim_start_matches("version = \"")
                .trim_end_matches("\";");
            return Some(inner.to_string());
        }
    }
    None
}

// ── fetch dispatch ────────────────────────────────────────────────────────────

fn fetch_latest(entry: &PkgEntry) -> (String, String) {
    match entry.source.as_str() {
        "github" => {
            let repo = entry.repo.as_deref().unwrap_or_else(|| {
                eprintln!("update-pkg: package {:?} missing 'repo'", entry.name);
                exit(1);
            });
            let asset = entry.asset.as_deref().unwrap_or_else(|| {
                eprintln!("update-pkg: package {:?} missing 'asset'", entry.name);
                exit(1);
            });
            fetch_github(repo, asset, entry.strip_v.unwrap_or(false))
        }
        "jetbrains" => {
            let code = entry.product_code.as_deref().unwrap_or_else(|| {
                eprintln!("update-pkg: package {:?} missing 'product_code'", entry.name);
                exit(1);
            });
            let template = entry.download_url_template.as_deref().unwrap_or_else(|| {
                eprintln!("update-pkg: package {:?} missing 'download_url_template'", entry.name);
                exit(1);
            });
            fetch_jetbrains(code, template)
        }
        other => {
            eprintln!("update-pkg: unknown source {:?} for package {:?}", other, entry.name);
            eprintln!("valid sources: github, jetbrains");
            exit(1);
        }
    }
}

// ── github ────────────────────────────────────────────────────────────────────

fn fetch_github(repo: &str, asset: &str, strip_v: bool) -> (String, String) {
    let api_url = format!("https://api.github.com/repos/{}/releases/latest", repo);
    let output = curl_get(&api_url);
    let body = String::from_utf8_lossy(&output.stdout);

    let tag = extract_json_str(&body, "tag_name").unwrap_or_else(|| {
        eprintln!("update-pkg: could not parse tag_name from GitHub response");
        eprintln!("response: {}", &body[..body.len().min(500)]);
        exit(1);
    });

    let version_for_asset = if strip_v {
        tag.trim_start_matches('v').to_string()
    } else {
        tag.clone()
    };

    let asset_name = asset.replace("VERSION", &version_for_asset);
    let download_url = format!(
        "https://github.com/{}/releases/download/{}/{}",
        repo, tag, asset_name
    );

    (tag, download_url)
}

// ── jetbrains ─────────────────────────────────────────────────────────────────

fn fetch_jetbrains(product_code: &str, url_template: &str) -> (String, String) {
    let api_url = format!(
        "https://data.services.jetbrains.com/products/releases?code={}&latest=true&type=release",
        product_code
    );

    let output = curl_get(&api_url);
    let body = String::from_utf8_lossy(&output.stdout);

    let version = extract_json_str(&body, "version").unwrap_or_else(|| {
        eprintln!("update-pkg: could not parse version from JetBrains API response");
        eprintln!("response: {}", &body[..body.len().min(500)]);
        exit(1);
    });

    let download_url = url_template.replace("VERSION", &version);

    (version, download_url)
}

// ── shared curl helper ────────────────────────────────────────────────────────

fn curl_get(url: &str) -> std::process::Output {
    let output = Command::new("curl")
        .args([
            "--silent",
            "--fail",
            "--location",
            "--header", "Accept: application/json",
            "--user-agent", "fomonix-orchestrator",
            url,
        ])
        .output()
        .unwrap_or_else(|e| {
            eprintln!("update-pkg: curl failed: {}", e);
            exit(1);
        });

    if !output.status.success() {
        eprintln!("update-pkg: request failed for {}", url);
        eprintln!("{}", String::from_utf8_lossy(&output.stderr));
        exit(1);
    }

    output
}

// ── nix-prefetch-url → SRI ────────────────────────────────────────────────────

fn prefetch_sri(url: &str, name: &str) -> String {
    println!("prefetching {} (this may take a moment)...", name);

    let output = Command::new("nix-prefetch-url")
        .args(["--type", "sha256", "--name", name, url])
        .output()
        .unwrap_or_else(|e| {
            eprintln!("update-pkg: nix-prefetch-url failed: {}", e);
            exit(1);
        });

    if !output.status.success() {
        eprintln!("update-pkg: nix-prefetch-url returned non-zero");
        eprintln!("{}", String::from_utf8_lossy(&output.stderr));
        exit(1);
    }

    let raw = String::from_utf8_lossy(&output.stdout).trim().to_string();

    let sri_output = Command::new("nix")
        .args(["hash", "to-sri", "--type", "sha256", &raw])
        .output()
        .unwrap_or_else(|e| {
            eprintln!("update-pkg: nix hash to-sri failed: {}", e);
            exit(1);
        });

    if !sri_output.status.success() {
        eprintln!("update-pkg: nix hash to-sri returned non-zero");
        eprintln!("{}", String::from_utf8_lossy(&sri_output.stderr));
        exit(1);
    }

    String::from_utf8_lossy(&sri_output.stdout).trim().to_string()
}

// ── in-place patch ────────────────────────────────────────────────────────────

fn patch_pkg_nix(path: &str, new_version: &str, new_hash: &str) {
    let content = std::fs::read_to_string(path).unwrap_or_else(|e| {
        eprintln!("update-pkg: could not read {}: {}", path, e);
        exit(1);
    });

    let patched: String = content
        .lines()
        .map(|line| {
            let trimmed = line.trim_start();

            if trimmed.starts_with("version = \"") && trimmed.ends_with("\";") {
                let indent = &line[..line.len() - trimmed.len()];
                return format!("{}version = \"{}\";", indent, new_version);
            }

            if trimmed.starts_with("hash = \"sha256-") && trimmed.ends_with("\";") {
                let indent = &line[..line.len() - trimmed.len()];
                return format!("{}hash = \"{}\";", indent, new_hash);
            }

            line.to_string()
        })
        .collect::<Vec<_>>()
        .join("\n");

    let final_content = if content.ends_with('\n') {
        format!("{}\n", patched)
    } else {
        patched
    };

    std::fs::write(path, final_content).unwrap_or_else(|e| {
        eprintln!("update-pkg: could not write {}: {}", path, e);
        exit(1);
    });
}

// ── minimal json string extractor ────────────────────────────────────────────

fn extract_json_str(json: &str, key: &str) -> Option<String> {
    let needle = format!("\"{}\":", key);
    let start = json.find(&needle)?;
    let after_colon = &json[start + needle.len()..].trim_start();
    if !after_colon.starts_with('"') {
        return None;
    }
    let inner = &after_colon[1..];
    let end = inner.find('"')?;
    Some(inner[..end].to_string())
}
