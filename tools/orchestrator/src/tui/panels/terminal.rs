use crossterm::event::{KeyCode, KeyEvent, KeyModifiers};
use ratatui::{prelude::*, widgets::*};
use crate::tui::app::Focus;
use crate::tui::running_command::RunningCommand;
use super::panel_block;

pub struct TerminalPanel {
    pub input:   String,
    pub running: Option<RunningCommand>,
}

impl TerminalPanel {
    pub fn new() -> Self {
        Self { input: String::new(), running: None }
    }

    pub fn is_busy(&self) -> bool {
        self.running.as_ref().map(|c| !c.is_finished()).unwrap_or(false)
    }

    pub fn handle_key(&mut self, key: KeyEvent) {
        // While a command is running, pass everything through to the pty
        if let Some(cmd) = &mut self.running {
            if !cmd.is_finished() {
                cmd.handle_key(key);
                return;
            }
            // Command finished — Enter dismisses and returns to input line.
            // Esc is intercepted by app.rs before reaching here (goes to sidebar).
            // Ctrl-C is intercepted by app.rs before reaching here (quits TUI).
            // Any other key is swallowed here (no accidental input after a command).
            if key.code == KeyCode::Enter {
                self.running = None;
            }
            return;
        }

        // Input line handling
        match key.code {
            KeyCode::Enter => {
                let cmd = self.input.trim().to_string();
                if !cmd.is_empty() {
                    self.running = Some(RunningCommand::spawn(&["sh", "-c", &cmd]));
                }
                self.input.clear();
            }
            KeyCode::Backspace => { self.input.pop(); }
            KeyCode::Char('c') if key.modifiers.contains(KeyModifiers::CONTROL) => {
                self.input.clear();
            }
            KeyCode::Char(c)
                if key.modifiers == KeyModifiers::NONE
                || key.modifiers == KeyModifiers::SHIFT =>
            {
                self.input.push(c);
            }
            _ => {}
        }
    }
}

pub fn render(frame: &mut Frame, area: Rect, panel: &TerminalPanel, focus: Focus) {
    // Single outer block — terminal-like: no nested output border.
    let outer = panel_block("Terminal", focus);
    let inner = outer.inner(area);
    frame.render_widget(outer, area);

    // Output fills the top; input/status line sits at the very bottom.
    let chunks = Layout::vertical([
        Constraint::Min(0),
        Constraint::Length(1),
    ])
    .split(inner);

    // ── pty output or idle hint ───────────────────────────────────────────────
    if let Some(cmd) = &panel.running {
        cmd.render(frame, chunks[0]);
    } else {
        frame.render_widget(
            Paragraph::new(Span::styled(
                "  type a command and press Enter",
                Style::default().fg(Color::DarkGray),
            )),
            chunks[0],
        );
    }

    // ── input / status line ───────────────────────────────────────────────────
    let running_now = panel.running.as_ref().map(|c| !c.is_finished()).unwrap_or(false);
    let finished_waiting = panel.running.is_some() && !running_now;

    let input_widget = if running_now {
        Paragraph::new(Span::styled(
            " running…",
            Style::default().fg(Color::DarkGray),
        ))
    } else if finished_waiting {
        Paragraph::new(Span::styled(
            " done  (Enter to clear)",
            Style::default().fg(Color::DarkGray),
        ))
    } else {
        Paragraph::new(Line::from(vec![
            Span::styled("$ ", Style::default().fg(Color::Cyan).add_modifier(Modifier::BOLD)),
            Span::styled(panel.input.clone(), Style::default().fg(Color::White)),
            Span::styled("█", Style::default().fg(Color::Cyan)),
        ]))
    };

    frame.render_widget(input_widget, chunks[1]);
}
