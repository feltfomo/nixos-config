use crossterm::event::{KeyCode, KeyEvent};
use ratatui::{prelude::*, widgets::*};
use crate::commands::generations::Generation;
use crate::config::FomonixConfig;
use crate::tui::app::Focus;
use crate::tui::running_command::RunningCommand;
use super::panel_block;

pub struct GenerationsPanel {
    pub gens:     Vec<Generation>,
    pub selected: usize,
    pub loading:  Option<RunningCommand>,
    pub running:  Option<RunningCommand>,
}

impl GenerationsPanel {
    pub fn new() -> Self {
        Self { gens: vec![], selected: 0, loading: None, running: None }
    }

    pub fn load(&mut self) {
        self.loading = Some(RunningCommand::spawn(&[
            "sudo", "nix-env", "--list-generations", "-p", "/nix/var/nix/profiles/system",
        ]));
    }

    pub fn is_busy(&self) -> bool {
        self.loading.is_some() || self.running.is_some()
    }

    /// Call every frame before draw. Promotes finished loading into parsed gens,
    /// and triggers a reload after a rollback/delete finishes.
    pub fn tick(&mut self) {
        if let Some(cmd) = &self.loading {
            if cmd.is_finished() {
                let text = cmd.screen_text();
                self.gens = text.lines().filter_map(parse_generation_line).collect();
                self.selected = self.gens.iter().position(|g| g.current).unwrap_or(0);
                self.loading = None;
            }
        }
        if let Some(cmd) = &self.running {
            if cmd.is_finished() {
                self.running = None;
                self.load();
            }
        }
    }

    pub fn handle_key(&mut self, key: KeyEvent, cfg: &FomonixConfig) {
        if let Some(cmd) = &mut self.loading {
            cmd.handle_key(key);
            return;
        }
        if let Some(cmd) = &mut self.running {
            cmd.handle_key(key);
            return;
        }

        match key.code {
            KeyCode::Up | KeyCode::Char('k') => {
                if self.selected > 0 { self.selected -= 1; }
            }
            KeyCode::Down | KeyCode::Char('j') => {
                if self.selected + 1 < self.gens.len() { self.selected += 1; }
            }
            KeyCode::Enter | KeyCode::Char('r') => {
                if let Some(gen) = self.gens.get(self.selected) {
                    let config_name = if cfg.default_config.is_empty() {
                        "fomonixHyprland"
                    } else {
                        cfg.default_config.as_str()
                    };
                    let flake   = format!("/etc/nixos#{}", config_name);
                    let gen_str = gen.id.to_string();
                    let cmd_str = format!(
                        "sudo nix-env --switch-generation {} -p /nix/var/nix/profiles/system && sudo nixos-rebuild switch --flake {}",
                        gen_str, flake
                    );
                    self.running = Some(RunningCommand::spawn(&["sh", "-c", &cmd_str]));
                }
            }
            KeyCode::Char('d') => {
                if let Some(gen) = self.gens.get(self.selected) {
                    if gen.current { return; }
                    let id_str = gen.id.to_string();
                    self.running = Some(RunningCommand::spawn(&[
                        "sudo", "nix-env", "--delete-generations", &id_str,
                        "-p", "/nix/var/nix/profiles/system",
                    ]));
                }
            }
            KeyCode::Char('R') => { self.load(); }
            _ => {}
        }
    }
}

fn parse_generation_line(line: &str) -> Option<Generation> {
    let trimmed = line.trim();
    if trimmed.is_empty() { return None; }
    let mut parts = trimmed.splitn(4, char::is_whitespace);
    let id: u32 = parts.next()?.trim().parse().ok()?;
    let date_part = parts.next()?.trim().to_string();
    let time_part = parts.next()?.trim().to_string();
    let rest = parts.next().unwrap_or("").trim();
    let current = rest.contains("(current)");
    Some(Generation { id, date: format!("{} {}", date_part, time_part), current })
}

pub fn render(
    frame: &mut Frame,
    area: Rect,
    panel: &GenerationsPanel,
    _cfg: &FomonixConfig,
    focus: Focus,
) {
    // While loading or running, show the pty full-width
    if let Some(cmd) = &panel.loading {
        let block = panel_block("Generations — loading…", focus);
        let inner = block.inner(area);
        frame.render_widget(block, area);
        cmd.render(frame, inner);
        return;
    }
    if let Some(cmd) = &panel.running {
        let block = panel_block("Generations — running…", focus);
        let inner = block.inner(area);
        frame.render_widget(block, area);
        cmd.render(frame, inner);
        return;
    }

    let hchunks = Layout::horizontal([
        Constraint::Percentage(60),
        Constraint::Percentage(40),
    ]).split(area);

    if panel.gens.is_empty() {
        frame.render_widget(
            Paragraph::new(vec![
                Line::from(""),
                Line::from(Span::styled("  No generations found.", Style::default().fg(Color::DarkGray))),
                Line::from(""),
                Line::from(Span::styled("  R  load", Style::default().fg(Color::Cyan))),
            ]).block(panel_block("Generations", focus)),
            hchunks[0],
        );
        frame.render_widget(
            Paragraph::new(vec![
                Line::from(""),
                Line::from(Span::styled("  R  load generations", Style::default().fg(Color::Cyan))),
            ]).block(panel_block("Actions", focus)),
            hchunks[1],
        );
        return;
    }

    let items: Vec<ListItem> = panel.gens.iter().map(|g| {
        let marker = if g.current { "*" } else { " " };
        let style  = if g.current { Style::default().fg(Color::Green) } else { Style::default().fg(Color::White) };
        ListItem::new(format!(" {} Gen {:>4}   {}", marker, g.id, g.date)).style(style)
    }).collect();

    let mut state = ListState::default().with_selected(Some(panel.selected));
    frame.render_stateful_widget(
        List::new(items)
            .block(panel_block("Generations", focus))
            .highlight_style(Style::default().fg(Color::Cyan).add_modifier(Modifier::BOLD))
            .highlight_symbol("> "),
        hchunks[0],
        &mut state,
    );

    let selected_gen = panel.gens.get(panel.selected);
    let action_lines = if let Some(gen) = selected_gen {
        let current_tag = if gen.current { "  (current)" } else { "" };
        let mut lines = vec![
            Line::from(""),
            Line::from(vec![
                Span::styled(format!("  Gen {}", gen.id), Style::default().fg(Color::Cyan).add_modifier(Modifier::BOLD)),
                Span::styled(current_tag, Style::default().fg(Color::Green)),
            ]),
            Line::from(Span::styled(format!("  {}", gen.date), Style::default().fg(Color::DarkGray))),
            Line::from(""),
            Line::from(Span::styled("  ─────────────────", Style::default().fg(Color::DarkGray))),
            Line::from(""),
            Line::from(vec![Span::styled("  Enter/r  ", Style::default().fg(Color::Cyan)),   Span::styled("rollback", Style::default().fg(Color::White))]),
            Line::from(vec![Span::styled("  d        ", Style::default().fg(Color::Red)),     Span::styled("delete",   Style::default().fg(Color::White))]),
            Line::from(vec![Span::styled("  R        ", Style::default().fg(Color::Yellow)),  Span::styled("refresh",  Style::default().fg(Color::White))]),
        ];
        if gen.current {
            lines.push(Line::from(""));
            lines.push(Line::from(Span::styled("  cannot delete current", Style::default().fg(Color::DarkGray))));
        }
        lines
    } else {
        vec![
            Line::from(""),
            Line::from(Span::styled("  R  load generations", Style::default().fg(Color::Cyan))),
        ]
    };

    frame.render_widget(
        Paragraph::new(action_lines).block(panel_block("Actions", focus)),
        hchunks[1],
    );
}
