use std::io;
use std::sync::atomic::Ordering;
use std::time::{Duration, Instant};
use crossterm::{
    event::{self, Event, KeyCode, KeyModifiers},
    execute,
    terminal::{disable_raw_mode, enable_raw_mode, EnterAlternateScreen, LeaveAlternateScreen},
};
use ratatui::{prelude::*, widgets::*};
use crate::config::{self, FomonixConfig};
use super::sidebar::Sidebar;
use super::panels::{self, PanelState};
use super::running_command::TERMINAL_UPDATED;
use super::system_info::SystemInfo;

#[derive(Debug, Clone, Copy, PartialEq)]
pub enum Focus {
    Sidebar,
    Panel,
}

#[derive(Debug, Clone, Copy, PartialEq)]
pub enum ToastKind {
    Success,
    Error,
}

pub struct Toast {
    pub message: String,
    pub kind:    ToastKind,
    pub born:    Instant,
}

impl Toast {
    pub fn success(msg: impl Into<String>) -> Self {
        Self { message: msg.into(), kind: ToastKind::Success, born: Instant::now() }
    }
    pub fn error(msg: impl Into<String>) -> Self {
        Self { message: msg.into(), kind: ToastKind::Error, born: Instant::now() }
    }
    pub fn expired(&self) -> bool {
        self.born.elapsed() > Duration::from_secs(4)
    }
}

pub struct App {
    pub cfg:         FomonixConfig,
    pub sidebar:     Sidebar,
    pub panel_state: PanelState,
    pub focus:       Focus,
    pub running:     bool,
    pub toast:       Option<Toast>,
    pub sysinfo:     SystemInfo,
}

impl App {
    pub fn new() -> Self {
        Self {
            cfg:         config::load(),
            sidebar:     Sidebar::new(),
            panel_state: PanelState::new(),
            focus:       Focus::Sidebar,
            running:     true,
            toast:       None,
            sysinfo:     SystemInfo::gather(),
        }
    }

    pub fn run(&mut self) -> io::Result<()> {
        enable_raw_mode()?;
        let mut stdout = io::stdout();
        execute!(stdout, EnterAlternateScreen)?;
        let backend = CrosstermBackend::new(stdout);
        let mut terminal = Terminal::new(backend)?;

        while self.running {
            self.panel_state.tick();

            if let Some(ok) = self.panel_state.poll_finished(&self.cfg) {
                self.toast = Some(if ok {
                    Toast::success("✓ task complete")
                } else {
                    Toast::error("✗ task failed")
                });
            }
            if self.toast.as_ref().map(|t| t.expired()).unwrap_or(false) {
                self.toast = None;
            }
            terminal.draw(|f| self.draw(f))?;
            self.handle_events()?;
        }

        disable_raw_mode()?;
        execute!(terminal.backend_mut(), LeaveAlternateScreen)?;
        Ok(())
    }

    fn draw(&mut self, frame: &mut Frame) {
        let area = frame.area();
        let root = Layout::vertical([Constraint::Min(0), Constraint::Length(1)]).split(area);
        let cols = Layout::horizontal([Constraint::Length(34), Constraint::Min(0)]).split(root[0]);

        let busy = self.panel_state.is_busy();

        super::sidebar::render(frame, cols[0], &self.sidebar, self.focus, &self.sysinfo);
        panels::render(frame, cols[1], &mut self.panel_state, &self.cfg, self.focus, busy);

        frame.render_widget(
            Paragraph::new(panels::hint(&self.panel_state, self.focus, busy))
                .style(Style::default().fg(Color::DarkGray)),
            root[1],
        );

        if let Some(toast) = &self.toast {
            render_toast(frame, area, toast);
        }
    }

    fn handle_events(&mut self) -> io::Result<()> {
        let busy = self.panel_state.is_busy();
        let timeout = if busy && TERMINAL_UPDATED.swap(false, Ordering::Relaxed) {
            Duration::from_millis(0)
        } else if busy {
            Duration::from_millis(20)
        } else if self.toast.is_some() {
            Duration::from_millis(250)
        } else {
            Duration::from_millis(100)
        };

        if !event::poll(timeout)? {
            return Ok(());
        }

        if let Event::Key(key) = event::read()? {
            if key.code == KeyCode::Char('c') && key.modifiers == KeyModifiers::CONTROL {
                self.running = false;
                return Ok(());
            }

            if busy {
                self.panel_state.handle_running_key(key);
                return Ok(());
            }

            if key.modifiers == KeyModifiers::NONE && key.code == KeyCode::Char('q') {
                self.running = false;
                return Ok(());
            }

            self.toast = None;

            match self.focus {
                Focus::Sidebar => self.handle_sidebar_key(key.code),
                Focus::Panel   => self.handle_panel_key(key),
            }
        }
        Ok(())
    }

    fn handle_sidebar_key(&mut self, code: KeyCode) {
        match code {
            KeyCode::Up   | KeyCode::Char('k') => self.sidebar.prev(),
            KeyCode::Down | KeyCode::Char('j') => self.sidebar.next(),
            KeyCode::Enter | KeyCode::Right | KeyCode::Char('l') => {
                self.panel_state.activate(self.sidebar.selected());
                self.focus = Focus::Panel;
            }
            _ => {}
        }
    }

    fn handle_panel_key(&mut self, key: event::KeyEvent) {
        if key.code == KeyCode::Esc
            || key.code == KeyCode::Left
            || key.code == KeyCode::Char('h')
        {
            self.focus = Focus::Sidebar;
            return;
        }
        self.panel_state.handle_key(key, &mut self.cfg);
    }
}

fn render_toast(frame: &mut Frame, area: Rect, toast: &Toast) {
    let msg        = &toast.message;
    let width      = (msg.len() + 6) as u16;
    let x          = area.x + area.width.saturating_sub(width + 1);
    let toast_area = Rect { x, y: area.y + 1, width, height: 3 };

    let (border_color, text_color, icon) = match toast.kind {
        ToastKind::Success => (Color::Green, Color::Green, "✓"),
        ToastKind::Error   => (Color::Red,   Color::Red,   "✗"),
    };

    let block = Block::bordered().border_style(Style::default().fg(border_color));
    let inner = block.inner(toast_area);
    frame.render_widget(Clear, toast_area);
    frame.render_widget(block, toast_area);
    frame.render_widget(
        Paragraph::new(Line::from(vec![
            Span::styled(format!("{} ", icon), Style::default().fg(text_color).add_modifier(Modifier::BOLD)),
            Span::styled(msg.clone(), Style::default().fg(text_color)),
        ]))
        .alignment(Alignment::Center),
        inner,
    );
}
