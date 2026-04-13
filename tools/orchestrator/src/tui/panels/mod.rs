pub mod cleanup;
pub mod generations;
pub mod rebuild;
pub mod settings;
pub mod terminal;

use crossterm::event::KeyEvent;
use ratatui::{prelude::*, text::{Line, Span}};
use crate::config::FomonixConfig;
use crate::tui::app::Focus;
use crate::tui::running_command::RunningCommand;
use crate::tui::sidebar::SidebarItem;

pub struct PanelState {
    pub active:      SidebarItem,
    pub rebuild:     rebuild::RebuildPanel,
    pub generations: generations::GenerationsPanel,
    pub cleanup:     cleanup::CleanupPanel,
    pub settings:    settings::SettingsPanel,
    pub terminal:    terminal::TerminalPanel,
}

impl PanelState {
    pub fn new() -> Self {
        Self {
            active:      SidebarItem::Rebuild,
            rebuild:     rebuild::RebuildPanel::new(),
            generations: generations::GenerationsPanel::new(),
            cleanup:     cleanup::CleanupPanel::new(),
            settings:    settings::SettingsPanel::new(),
            terminal:    terminal::TerminalPanel::new(),
        }
    }

    pub fn activate(&mut self, item: SidebarItem) {
        self.active = item;

        if item == SidebarItem::Generations
            && self.generations.loading.is_none()
            && self.generations.gens.is_empty()
        {
            self.generations.load();
        }

        // Clear any finished terminal command when navigating back to Terminal.
        // A still-running command is preserved so it keeps running in the background.
        if item == SidebarItem::Terminal {
            if let Some(cmd) = &self.terminal.running {
                if cmd.is_finished() {
                    self.terminal.running = None;
                }
            }
        }
    }

    pub fn tick(&mut self) {
        self.generations.tick();
    }

    pub fn is_busy(&self) -> bool {
        match self.active {
            SidebarItem::Rebuild     => self.rebuild.running.is_some(),
            SidebarItem::Cleanup     => self.cleanup.running.is_some(),
            SidebarItem::Generations => self.generations.is_busy(),
            SidebarItem::Terminal    => self.terminal.is_busy(),
            SidebarItem::Settings    => false,
        }
    }

    pub fn poll_finished(&mut self, cfg: &FomonixConfig) -> Option<bool> {
        let result = match self.active {
            SidebarItem::Rebuild     => poll_cmd(&mut self.rebuild.running),
            SidebarItem::Cleanup     => poll_cmd(&mut self.cleanup.running),
            SidebarItem::Generations => None,
            SidebarItem::Terminal    => None, // terminal manages its own lifecycle
            SidebarItem::Settings    => None,
        };

        if let Some(ok) = result {
            if let SidebarItem::Rebuild = self.active {
                if ok && cfg.auto_qs_clean {
                    crate::commands::qs_clean::run_silent(&mut vec![]);
                }
            }
        }

        result
    }

    pub fn handle_running_key(&mut self, key: KeyEvent) {
        match self.active {
            SidebarItem::Rebuild     => { if let Some(c) = &mut self.rebuild.running     { c.handle_key(key); } }
            SidebarItem::Cleanup     => { if let Some(c) = &mut self.cleanup.running     { c.handle_key(key); } }
            SidebarItem::Generations => self.generations.handle_key(key, &FomonixConfig::default()),
            SidebarItem::Terminal    => self.terminal.handle_key(key),
            SidebarItem::Settings    => {}
        }
    }

    pub fn handle_key(&mut self, key: KeyEvent, cfg: &mut FomonixConfig) {
        match self.active {
            SidebarItem::Rebuild     => self.rebuild.handle_key(key, cfg),
            SidebarItem::Generations => self.generations.handle_key(key, cfg),
            SidebarItem::Cleanup     => self.cleanup.handle_key(key),
            SidebarItem::Settings    => self.settings.handle_key(key.code, cfg),
            SidebarItem::Terminal    => self.terminal.handle_key(key),
        }
    }
}

fn poll_cmd(slot: &mut Option<RunningCommand>) -> Option<bool> {
    if let Some(cmd) = slot {
        if cmd.is_finished() {
            let ok = cmd.exit_ok();
            *slot = None;
            return Some(ok);
        }
    }
    None
}

pub fn render(
    frame: &mut Frame,
    area: Rect,
    state: &mut PanelState,
    cfg: &FomonixConfig,
    focus: Focus,
    busy: bool,
) {
    match state.active {
        SidebarItem::Rebuild     => rebuild::render(frame, area, &state.rebuild, cfg, focus, busy),
        SidebarItem::Generations => generations::render(frame, area, &state.generations, cfg, focus),
        SidebarItem::Cleanup     => cleanup::render(frame, area, &state.cleanup, focus, busy),
        SidebarItem::Settings    => settings::render(frame, area, &state.settings, cfg, focus),
        SidebarItem::Terminal    => terminal::render(frame, area, &state.terminal, focus),
    }
}

pub fn hint(state: &PanelState, focus: Focus, busy: bool) -> &'static str {
    if busy {
        return "Ctrl-C  interrupt   Enter  dismiss when done";
    }
    match focus {
        Focus::Sidebar => "j/k move   Enter select   q quit",
        Focus::Panel   => match state.active {
            SidebarItem::Rebuild     => "j/k move   left/right toggle   Enter run   Esc back   q quit",
            SidebarItem::Generations => "j/k select   Enter rollback   d delete   R refresh   Esc back",
            SidebarItem::Cleanup     => "j/k select   Enter run   Esc back   q quit",
            SidebarItem::Settings    => "j/k move   left/right toggle   Enter save   Esc back   q quit",
            SidebarItem::Terminal    => "type command   Enter run   Backspace delete   Esc back   q quit",
        },
    }
}

pub fn panel_block(title: &str, focus: Focus) -> ratatui::widgets::Block<'static> {
    use ratatui::widgets::*;
    let color = if focus == Focus::Panel { Color::Cyan } else { Color::DarkGray };
    Block::bordered()
        .title(format!(" {} ", title))
        .border_style(Style::default().fg(color))
}

pub fn render_row(
    frame: &mut Frame,
    x: u16, y: u16, width: u16,
    label: &str, value: &str,
    selected: bool,
    value_color: Color,
) {
    use ratatui::widgets::*;
    let (arrow, label_style, value_style) = if selected {
        (
            "> ",
            Style::default().fg(Color::Cyan).add_modifier(Modifier::BOLD),
            Style::default().fg(Color::Cyan).add_modifier(Modifier::BOLD),
        )
    } else {
        (
            "  ",
            Style::default().fg(Color::White),
            Style::default().fg(value_color),
        )
    };
    frame.render_widget(
        Paragraph::new(Line::from(vec![
            Span::raw(arrow),
            Span::styled(format!("{:<16}", label), label_style),
            Span::styled(value.to_owned(), value_style),
        ])),
        Rect { x, y, width, height: 1 },
    );
}
