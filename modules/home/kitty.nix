{ config, pkgs, ... }:

{
  programs.kitty = {
    enable = true;

    font = {
      name = "JetBrains Mono Nerd Font";
      size = 12.0;
    };

    settings = {
      # Font
      bold_font = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";
      disable_ligatures = "never";

      # Cursor
      cursor_shape = "underline";
      cursor_beam_thickness = "2.0";
      cursor_underline_thickness = "2.0";
      cursor_blink_interval = "0.5";
      cursor_stop_blinking_after = "15.0";

      # Mouse
      mouse_hide_wait = "3.0";
      url_style = "curly";
      open_url_with = "default";
      url_prefixes = "file ftp ftps gemini git gopher http https irc ircs kitty mailto news sftp ssh";
      detect_urls = "yes";
      copy_on_select = "yes";

      # Window
      window_padding_width = 12;
      window_border_width = "1pt";
      draw_minimal_borders = "yes";
      remember_window_size = "no";
      initial_window_width = 1200;
      initial_window_height = 700;
      background_opacity = "0.85";
      dynamic_background_opacity = "yes";
      confirm_os_window_close = 0;

      # Layouts
      enabled_layouts = "splits,stack";

      # Tab bar
      tab_bar_edge = "top";
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
      tab_bar_min_tabs = 2;

      # Bell
      enable_audio_bell = "no";
      visual_bell_duration = "0.0";
      window_alert_on_bell = "yes";
      bell_on_tab = "\"🔔 \"";

      # Performance
      repaint_delay = 6;
      input_delay = 1;
      sync_to_monitor = "yes";

      # Advanced
      allow_remote_control = "yes";
      listen_on = "unix:/tmp/kitty";

      # Shell integration
      shell_integration = "enabled";

      # Scrollback
      scrollback_lines = 10000;
      scrollback_pager = "less --chop-long-lines --RAW-CONTROL-CHARS +INPUT_LINE_NUMBER";

      # Catppuccin Mocha colors
      foreground = "#CDD6F4";
      background = "#1E1E2E";
      selection_foreground = "#1E1E2E";
      selection_background = "#F5E0DC";
      cursor = "#F5E0DC";
      cursor_text_color = "#1E1E2E";
      url_color = "#B4BEFE";

      active_border_color = "#CBA6F7";
      inactive_border_color = "#6C7086";
      bell_border_color = "#F9E2AF";
      wayland_titlebar_color = "system";

      active_tab_foreground = "#11111B";
      active_tab_background = "#CBA6F7";
      inactive_tab_foreground = "#CDD6F4";
      inactive_tab_background = "#181825";
      tab_bar_background = "#11111B";

      mark1_foreground = "#1E1E2E";
      mark1_background = "#B4BEFE";
      mark2_foreground = "#1E1E2E";
      mark2_background = "#CBA6F7";
      mark3_foreground = "#1E1E2E";
      mark3_background = "#74C7EC";

      # Terminal colors
      color0 = "#45475A";
      color8 = "#585B70";
      color1 = "#F38BA8";
      color9 = "#F38BA8";
      color2 = "#A6E3A1";
      color10 = "#A6E3A1";
      color3 = "#F9E2AF";
      color11 = "#F9E2AF";
      color4 = "#89B4FA";
      color12 = "#89B4FA";
      color5 = "#F5C2E7";
      color13 = "#F5C2E7";
      color6 = "#94E2D5";
      color14 = "#94E2D5";
      color7 = "#BAC2DE";
      color15 = "#A6ADC8";
    };

    # DMS generates dank-theme.conf and dank-tabs.conf at runtime,
    # so we include them here but leave them unmanaged by Nix.
    extraConfig = ''
      include dank-theme.conf
      include dank-tabs.conf
    '';
  };
}
