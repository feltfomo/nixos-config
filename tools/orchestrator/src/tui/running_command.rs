use std::io::{Read, Write};
use std::sync::{Arc, Mutex};
use std::sync::atomic::{AtomicBool, Ordering};
use std::thread;
use crossterm::event::{KeyCode, KeyEvent, KeyModifiers};
use portable_pty::{CommandBuilder, NativePtySystem, PtySize, PtySystem};
use ratatui::prelude::*;
use tui_term::widget::PseudoTerminal;

pub static TERMINAL_UPDATED: AtomicBool = AtomicBool::new(false);

pub struct RunningCommand {
    parser:   Arc<Mutex<vt100::Parser>>,
    writer:   Box<dyn Write + Send>,
    finished: Arc<AtomicBool>,
    exit_ok:  Arc<Mutex<Option<bool>>>,
}

impl RunningCommand {
    /// Spawn with the default pty size (50 rows × 220 cols).
    /// Use `spawn_sized` when you know the render area dimensions.
    pub fn spawn(argv: &[&str]) -> Self {
        Self::spawn_sized(argv, 50, 220)
    }

    /// Spawn with an explicit pty size. Prefer this when the render area is
    /// known so the vt100 screen matches the widget area and there is no blank
    /// space at the bottom of the output.
    pub fn spawn_sized(argv: &[&str], rows: u16, cols: u16) -> Self {
        assert!(!argv.is_empty(), "argv must not be empty");

        let pty_sys = NativePtySystem::default();
        let pair = pty_sys
            .openpty(PtySize { rows, cols, pixel_width: 0, pixel_height: 0 })
            .expect("openpty failed");

        let mut cmd = CommandBuilder::new(argv[0]);
        for arg in &argv[1..] {
            cmd.arg(arg);
        }

        let mut child  = pair.slave.spawn_command(cmd).expect("spawn failed");
        drop(pair.slave);

        let writer     = pair.master.take_writer().expect("take_writer failed");
        let mut reader = pair.master.try_clone_reader().expect("clone_reader failed");

        let parser   = Arc::new(Mutex::new(vt100::Parser::new(rows, cols, 0)));
        let finished = Arc::new(AtomicBool::new(false));
        let exit_ok  = Arc::new(Mutex::new(None::<bool>));

        {
            let parser   = parser.clone();
            let finished = finished.clone();
            let exit_ok  = exit_ok.clone();
            thread::spawn(move || {
                let mut buf = [0u8; 4096];
                loop {
                    match reader.read(&mut buf) {
                        Ok(0) | Err(_) => break,
                        Ok(n) => {
                            parser.lock().unwrap().process(&buf[..n]);
                            TERMINAL_UPDATED.store(true, Ordering::Relaxed);
                        }
                    }
                }
                let ok = child.wait().map(|s| s.success()).unwrap_or(false);
                *exit_ok.lock().unwrap() = Some(ok);
                finished.store(true, Ordering::Relaxed);
                TERMINAL_UPDATED.store(true, Ordering::Relaxed);
            });
        }

        Self { parser, writer, finished, exit_ok }
    }

    pub fn is_finished(&self) -> bool {
        self.finished.load(Ordering::Relaxed)
    }

    pub fn exit_ok(&self) -> bool {
        self.exit_ok.lock().unwrap().unwrap_or(false)
    }

    /// Scrape plain text from the vt100 screen. Used to parse command output
    /// after the command finishes (e.g. GenerationsPanel parsing nix-env output).
    pub fn screen_text(&self) -> String {
        self.parser.lock().unwrap().screen().contents()
    }

    pub fn handle_key(&mut self, key: KeyEvent) {
        if self.is_finished() {
            return;
        }
        let bytes: Vec<u8> = match key.code {
            KeyCode::Char('c') if key.modifiers.contains(KeyModifiers::CONTROL) => vec![0x03],
            KeyCode::Char(c)   => c.to_string().into_bytes(),
            KeyCode::Enter     => vec![b'\r'],
            KeyCode::Backspace => vec![0x7f],
            KeyCode::Tab       => vec![b'\t'],
            KeyCode::Esc       => vec![0x1b],
            KeyCode::Up        => vec![0x1b, b'[', b'A'],
            KeyCode::Down      => vec![0x1b, b'[', b'B'],
            KeyCode::Left      => vec![0x1b, b'[', b'D'],
            KeyCode::Right     => vec![0x1b, b'[', b'C'],
            _ => vec![],
        };
        if !bytes.is_empty() {
            let _ = self.writer.write_all(&bytes);
        }
    }

    pub fn render(&self, frame: &mut Frame, area: Rect) {
        let parser = self.parser.lock().unwrap();
        frame.render_widget(PseudoTerminal::new(parser.screen()), area);
    }
}
