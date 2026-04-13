use ratatui::{prelude::*, widgets::*};
use crate::tui::app::Focus;
use crate::tui::system_info::SystemInfo;

#[derive(Debug, Clone, Copy, PartialEq)]
pub enum SidebarItem {
    Rebuild,
    Generations,
    Cleanup,
    Settings,
    Terminal,
}

impl SidebarItem {
    pub const ALL: &'static [Self] = &[
        Self::Rebuild,
        Self::Generations,
        Self::Cleanup,
        Self::Settings,
        Self::Terminal,
    ];

    pub fn label(&self) -> &'static str {
        match self {
            Self::Rebuild     => "Rebuild",
            Self::Generations => "Generations",
            Self::Cleanup     => "Cleanup",
            Self::Settings    => "Settings",
            Self::Terminal    => "Terminal",
        }
    }
}

pub struct Sidebar {
    pub index: usize,
}

impl Sidebar {
    pub fn new() -> Self {
        Self { index: 0 }
    }

    pub fn selected(&self) -> SidebarItem {
        SidebarItem::ALL[self.index]
    }

    pub fn next(&mut self) {
        if self.index + 1 < SidebarItem::ALL.len() { self.index += 1; }
    }

    pub fn prev(&mut self) {
        if self.index > 0 { self.index -= 1; }
    }
}

// 10 data rows + 2 border lines
const SYSINFO_HEIGHT: u16 = 12;

pub fn render(frame: &mut Frame, area: Rect, sidebar: &Sidebar, focus: Focus, sysinfo: &SystemInfo) {
    let nav_border_style = if focus == Focus::Sidebar {
        Style::default().fg(Color::Cyan)
    } else {
        Style::default().fg(Color::DarkGray)
    };

    let chunks = Layout::vertical([
        Constraint::Min(0),
        Constraint::Length(SYSINFO_HEIGHT),
    ]).split(area);

    let block = Block::bordered()
        .title(" fomonix ")
        .title_alignment(Alignment::Center)
        .border_style(nav_border_style);

    let inner = block.inner(chunks[0]);
    frame.render_widget(block, chunks[0]);

    let items: Vec<ListItem> = SidebarItem::ALL
        .iter()
        .map(|item| ListItem::new(format!(" {}", item.label())))
        .collect();

    let mut state = ListState::default().with_selected(Some(sidebar.index));
    frame.render_stateful_widget(
        List::new(items)
            .highlight_style(Style::default().fg(Color::Cyan).add_modifier(Modifier::BOLD))
            .highlight_symbol("> ")
            .highlight_spacing(HighlightSpacing::Always),
        inner,
        &mut state,
    );

    render_sysinfo(frame, chunks[1], sysinfo);
}

fn render_sysinfo(frame: &mut Frame, area: Rect, info: &SystemInfo) {
    let block = Block::bordered()
        .title(" system ")
        .border_style(Style::default().fg(Color::DarkGray));

    let inner = block.inner(area);
    frame.render_widget(block, area);

    let rows: &[(&str, &str)] = &[
        ("host",   &info.hostname),
        ("os",     &info.channel),
        ("kernel", &info.kernel),
        ("gen",    &info.current_gen),
        ("rev",    &info.flake_rev),
        ("cpu",    &info.cpu),
        ("ram",    &info.ram),
        ("gpu",    &info.gpu),
        ("disk",   &info.disk),
        ("up",     &info.uptime),
    ];

    for (i, (label, value)) in rows.iter().enumerate() {
        let y = inner.y + i as u16;
        if y >= inner.y + inner.height { break; }
        let row_area = Rect { x: inner.x, y, width: inner.width, height: 1 };
        frame.render_widget(
            Paragraph::new(Line::from(vec![
                Span::styled(
                    format!("{:>6} ", label),
                    Style::default().fg(Color::DarkGray).add_modifier(Modifier::BOLD),
                ),
                Span::styled(
                    truncate(value, inner.width.saturating_sub(8) as usize),
                    Style::default().fg(Color::Gray),
                ),
            ])),
            row_area,
        );
    }
}

fn truncate(s: &str, max: usize) -> String {
    if max == 0 { return String::new(); }
    let chars: Vec<char> = s.chars().collect();
    if chars.len() <= max {
        s.to_string()
    } else if max <= 3 {
        chars.iter().take(max).collect()
    } else {
        let trimmed: String = chars.iter().take(max - 3).collect();
        format!("{}...", trimmed)
    }
}
