use crossterm::event::KeyCode;
use ratatui::{prelude::*, widgets::*};
use crate::config::{self, FomonixConfig};
use crate::tui::app::Focus;
use super::panel_block;

#[derive(Clone, Copy, PartialEq)]
enum Field {
    AutoSync,
    AutoQsClean,
    DefaultConfig,
    Save,
}

const FIELDS: &[Field] = &[
    Field::AutoSync,
    Field::AutoQsClean,
    Field::DefaultConfig,
    Field::Save,
];

pub struct SettingsPanel {
    pub field: usize,
    pub saved: bool,
}

impl SettingsPanel {
    pub fn new() -> Self {
        Self { field: 0, saved: false }
    }

    pub fn handle_key(&mut self, code: KeyCode, cfg: &mut FomonixConfig) {
        self.saved = false;
        match code {
            KeyCode::Up | KeyCode::Char('k') => {
                if self.field > 0 { self.field -= 1; }
            }
            KeyCode::Down | KeyCode::Char('j') => {
                if self.field + 1 < FIELDS.len() { self.field += 1; }
            }
            KeyCode::Left | KeyCode::Right | KeyCode::Enter => {
                match FIELDS[self.field] {
                    Field::AutoSync    => { cfg.auto_sync     = !cfg.auto_sync; }
                    Field::AutoQsClean => { cfg.auto_qs_clean = !cfg.auto_qs_clean; }
                    Field::DefaultConfig => {
                        cfg.default_config = match cfg.default_config.as_str() {
                            ""                => "fomonix".to_string(),
                            "fomonix"         => "fomonixHyprland".to_string(),
                            "fomonixHyprland" => String::new(),
                            _                 => String::new(),
                        };
                    }
                    Field::Save => {
                        config::save(cfg);
                        self.saved = true;
                    }
                }
            }
            _ => {}
        }
    }
}

pub fn render(frame: &mut Frame, area: Rect, panel: &SettingsPanel, cfg: &FomonixConfig, focus: Focus) {
    let block = panel_block("Settings", focus);
    let inner = block.inner(area);
    frame.render_widget(block, area);

    let default_config_label = match cfg.default_config.as_str() {
        "fomonix"         => "[ fomonix (niri) ]",
        "fomonixHyprland" => "[ fomonixHyprland (hyprland) ]",
        _                 => "[ prompt ]",
    };

    let rows: &[(&str, &str, &str, Field)] = &[
        ("Auto Sync",      "Run sync before every rebuild",            if cfg.auto_sync     { "[ on ]" } else { "[ off ]" }, Field::AutoSync),
        ("Auto QS Clean",  "Clear noctalia-qs cache after rebuild",    if cfg.auto_qs_clean { "[ on ]" } else { "[ off ]" }, Field::AutoQsClean),
        ("Default Config", "Skip config prompt on rebuild",            default_config_label,                                 Field::DefaultConfig),
    ];

    frame.render_widget(
        Paragraph::new(Span::styled(
            "  Changes are written back to _config.nix",
            Style::default().fg(Color::DarkGray),
        )),
        Rect { x: inner.x, y: inner.y + 1, width: inner.width, height: 1 },
    );

    for (i, (label, desc, value, field)) in rows.iter().enumerate() {
        let selected = FIELDS[panel.field] == *field && focus == Focus::Panel;
        let y_base   = inner.y + 3 + i as u16 * 4;
        let arrow    = if selected { "> " } else { "  " };

        let label_style = if selected {
            Style::default().fg(Color::Cyan).add_modifier(Modifier::BOLD)
        } else {
            Style::default().fg(Color::White)
        };
        let value_style = if selected {
            Style::default().fg(Color::Cyan).add_modifier(Modifier::BOLD)
        } else if *value == "[ on ]" {
            Style::default().fg(Color::Green)
        } else if *value == "[ off ]" {
            Style::default().fg(Color::DarkGray)
        } else {
            Style::default().fg(Color::Yellow)
        };

        frame.render_widget(
            Paragraph::new(Line::from(vec![
                Span::raw(arrow),
                Span::styled(format!("{:<20}", label), label_style),
                Span::styled(*value, value_style),
            ])),
            Rect { x: inner.x, y: y_base, width: inner.width, height: 1 },
        );
        frame.render_widget(
            Paragraph::new(Span::styled(
                format!("    {}", desc),
                Style::default().fg(Color::DarkGray),
            )),
            Rect { x: inner.x, y: y_base + 1, width: inner.width, height: 1 },
        );
    }

    let save_y        = inner.y + 3 + rows.len() as u16 * 4;
    let save_selected = FIELDS[panel.field] == Field::Save && focus == Focus::Panel;
    let (save_label, save_style) = if panel.saved {
        ("  ✓ saved to _config.nix", Style::default().fg(Color::Green).add_modifier(Modifier::BOLD))
    } else if save_selected {
        ("> Save to _config.nix",    Style::default().fg(Color::Green).add_modifier(Modifier::BOLD))
    } else {
        ("  Save to _config.nix",    Style::default().fg(Color::Green))
    };
    frame.render_widget(
        Paragraph::new(Span::styled(save_label, save_style)),
        Rect { x: inner.x, y: save_y, width: inner.width, height: 1 },
    );
}
