use crossterm::event::{KeyCode, KeyEvent};
use ratatui::{prelude::*, widgets::*};
use crate::tui::app::Focus;
use crate::tui::running_command::RunningCommand;
use super::panel_block;

#[derive(Clone, Copy, PartialEq)]
pub enum CleanupItem {
    GcClean,
    QsClean,
}

impl CleanupItem {
    const ALL: &'static [Self] = &[Self::GcClean, Self::QsClean];

    fn label(&self) -> &'static str {
        match self {
            Self::GcClean => "GC Clean",
            Self::QsClean => "QS Clean",
        }
    }

    fn description(&self) -> &'static str {
        match self {
            Self::GcClean => "Collect all nix garbage, free store space",
            Self::QsClean => "Clear noctalia quickshell cache",
        }
    }
}

pub struct CleanupPanel {
    pub selected: usize,
    pub running:  Option<RunningCommand>,
}

impl CleanupPanel {
    pub fn new() -> Self {
        Self { selected: 0, running: None }
    }

    pub fn handle_key(&mut self, key: KeyEvent) {
        match key.code {
            KeyCode::Up | KeyCode::Char('k') => {
                if self.selected > 0 { self.selected -= 1; }
            }
            KeyCode::Down | KeyCode::Char('j') => {
                if self.selected + 1 < CleanupItem::ALL.len() { self.selected += 1; }
            }
            KeyCode::Enter | KeyCode::Char('r') => {
                if self.running.is_some() {
                    return;
                }
                match CleanupItem::ALL[self.selected] {
                    CleanupItem::GcClean => {
                        self.running = Some(RunningCommand::spawn(&[
                            "sudo", "nix-collect-garbage", "-d",
                        ]));
                    }
                    CleanupItem::QsClean => {
                        crate::commands::qs_clean::run_silent(&mut vec![]);
                    }
                }
            }
            _ => {}
        }
    }
}

pub fn render(frame: &mut Frame, area: Rect, panel: &CleanupPanel, focus: Focus, busy: bool) {
    let chunks = Layout::vertical([Constraint::Length(10), Constraint::Min(0)]).split(area);

    let block = panel_block("Cleanup", focus);
    let inner = block.inner(chunks[0]);
    frame.render_widget(block, chunks[0]);

    for (i, item) in CleanupItem::ALL.iter().enumerate() {
        let selected = panel.selected == i && focus == Focus::Panel && !busy;
        let y = inner.y + 1 + i as u16 * 4;

        let (arrow, label_style, desc_style) = if selected {
            (
                "> ",
                Style::default().fg(Color::Cyan).add_modifier(Modifier::BOLD),
                Style::default().fg(Color::Cyan),
            )
        } else {
            (
                "  ",
                Style::default().fg(Color::White),
                Style::default().fg(Color::DarkGray),
            )
        };

        frame.render_widget(
            Paragraph::new(Line::from(vec![
                Span::raw(arrow),
                Span::styled(item.label(), label_style),
            ])),
            Rect { x: inner.x, y, width: inner.width, height: 1 },
        );
        frame.render_widget(
            Paragraph::new(Span::styled(
                format!("    {}", item.description()),
                desc_style,
            )),
            Rect { x: inner.x, y: y + 1, width: inner.width, height: 1 },
        );
    }

    let out_title = if busy { " Output  running... " } else { " Output " };
    let out_block = panel_block(out_title, focus);
    let out_inner = out_block.inner(chunks[1]);
    frame.render_widget(out_block, chunks[1]);
    if let Some(cmd) = &panel.running {
        cmd.render(frame, out_inner);
    }
}
