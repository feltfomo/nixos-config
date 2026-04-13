use crossterm::event::{KeyCode, KeyEvent};
use ratatui::{prelude::*, widgets::*};
use crate::config::FomonixConfig;
use crate::tui::app::Focus;
use crate::tui::running_command::RunningCommand;
use super::{panel_block, render_row};

#[derive(Debug, Clone, Copy, PartialEq)]
pub enum RebuildConfig {
    Niri,
    Hyprland,
}

impl RebuildConfig {
    fn label(&self) -> &'static str {
        match self {
            Self::Niri     => "[ fomonix (niri) ]",
            Self::Hyprland => "[ fomonixHyprland (hyprland) ]",
        }
    }

    fn flake_name(&self) -> &'static str {
        match self {
            Self::Niri     => "fomonix",
            Self::Hyprland => "fomonixHyprland",
        }
    }

    fn toggle(self) -> Self {
        match self { Self::Niri => Self::Hyprland, Self::Hyprland => Self::Niri }
    }

    fn from_cfg(s: &str) -> Self {
        if s == "fomonixHyprland" { Self::Hyprland } else { Self::Niri }
    }
}

#[derive(Debug, Clone, Copy, PartialEq)]
pub enum RebuildAction {
    Switch,
    DryRun,
}

#[derive(Debug, Clone, Copy, PartialEq)]
enum Field {
    Config,
    Action,
    AutoSync,
    AutoQsClean,
    Confirm,
}

const FIELDS: &[Field] = &[
    Field::Config,
    Field::Action,
    Field::AutoSync,
    Field::AutoQsClean,
    Field::Confirm,
];

pub struct RebuildPanel {
    pub field:   usize,
    pub config:  RebuildConfig,
    pub action:  RebuildAction,
    pub running: Option<RunningCommand>,
}

impl RebuildPanel {
    pub fn new() -> Self {
        Self {
            field:   0,
            config:  RebuildConfig::Niri,
            action:  RebuildAction::Switch,
            running: None,
        }
    }

    pub fn handle_key(&mut self, key: KeyEvent, cfg: &mut FomonixConfig) {
        self.config = RebuildConfig::from_cfg(&cfg.default_config);

        match key.code {
            KeyCode::Up | KeyCode::Char('k') => {
                if self.field > 0 { self.field -= 1; }
            }
            KeyCode::Down | KeyCode::Char('j') => {
                if self.field + 1 < FIELDS.len() { self.field += 1; }
            }
            KeyCode::Left | KeyCode::Right | KeyCode::Enter => {
                match FIELDS[self.field] {
                    Field::Config => {
                        self.config = self.config.toggle();
                        cfg.default_config = self.config.flake_name().to_string();
                    }
                    Field::Action => {
                        self.action = match self.action {
                            RebuildAction::Switch  => RebuildAction::DryRun,
                            RebuildAction::DryRun  => RebuildAction::Switch,
                        };
                    }
                    Field::AutoSync    => { cfg.auto_sync     = !cfg.auto_sync; }
                    Field::AutoQsClean => { cfg.auto_qs_clean = !cfg.auto_qs_clean; }
                    Field::Confirm if key.code == KeyCode::Enter => {
                        self.execute(cfg);
                    }
                    _ => {}
                }
            }
            _ => {}
        }
    }

    fn execute(&mut self, cfg: &FomonixConfig) {
        if self.running.is_some() {
            return;
        }
        if cfg.auto_sync {
            crate::commands::sync::run_silent(&mut vec![]);
        }
        let flake  = format!("/etc/nixos#{}", self.config.flake_name());
        let action = match self.action {
            RebuildAction::Switch  => "switch",
            RebuildAction::DryRun  => "dry-activate",
        };
        self.running = Some(RunningCommand::spawn(&[
            "sudo", "nixos-rebuild", action, "--flake", &flake,
        ]));
    }
}

pub fn render(
    frame: &mut Frame,
    area: Rect,
    panel: &RebuildPanel,
    cfg: &FomonixConfig,
    focus: Focus,
    busy: bool,
) {
    let chunks = Layout::vertical([Constraint::Length(13), Constraint::Min(0)]).split(area);

    let block = panel_block("Rebuild", focus);
    let inner = block.inner(chunks[0]);
    frame.render_widget(block, chunks[0]);

    let rows: &[(&str, &str, Field, Color)] = &[
        ("Config",        panel.config.label(),                                                              Field::Config,      Color::Yellow),
        ("Action",        if panel.action == RebuildAction::Switch { "[ switch ]" } else { "[ dry-run ]" }, Field::Action,      Color::Yellow),
        ("Auto Sync",     if cfg.auto_sync     { "on" } else { "off" },                                     Field::AutoSync,    Color::White),
        ("Auto QS Clean", if cfg.auto_qs_clean { "on" } else { "off" },                                     Field::AutoQsClean, Color::White),
    ];

    for (i, (label, value, field, color)) in rows.iter().enumerate() {
        let selected = FIELDS[panel.field] == *field && focus == Focus::Panel && !busy;
        render_row(frame, inner.x, inner.y + 1 + i as u16 * 2, inner.width, label, value, selected, *color);
    }

    let confirm_y        = inner.y + 1 + rows.len() as u16 * 2;
    let confirm_selected = FIELDS[panel.field] == Field::Confirm && focus == Focus::Panel && !busy;
    let (label, style)   = if busy {
        ("  running...", Style::default().fg(Color::Yellow))
    } else if confirm_selected {
        ("> Run Rebuild", Style::default().fg(Color::Cyan).add_modifier(Modifier::BOLD))
    } else {
        ("  Run Rebuild", Style::default().fg(Color::Green))
    };
    frame.render_widget(
        Paragraph::new(label).style(style),
        Rect { x: inner.x, y: confirm_y, width: inner.width, height: 1 },
    );

    let out_title = if busy { " Output  running... " } else { " Output " };
    let out_block = panel_block(out_title, focus);
    let out_inner = out_block.inner(chunks[1]);
    frame.render_widget(out_block, chunks[1]);
    if let Some(cmd) = &panel.running {
        cmd.render(frame, out_inner);
    }
}
