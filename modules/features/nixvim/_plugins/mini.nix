{ ... }:
{
  plugins.mini = {
    enable = true;
    modules = {
      # Extended text objects: iq/aq (quotes), ib/ab (brackets), if/af (function), ic/ac (class), etc.
      ai = {
        n_lines = 500;
        search_method = "cover_or_next";
      };

      # Move lines/selections with Alt+hjkl
      move = {
        mappings = {
          # Normal mode — move current line
          line_left = "<M-h>";
          line_right = "<M-l>";
          line_down = "<M-j>";
          line_up = "<M-k>";
          # Visual mode — move selection
          left = "<M-h>";
          right = "<M-l>";
          down = "<M-j>";
          up = "<M-k>";
        };
      };

      # Split: gS on a one-liner expands it; join: gJ on a block collapses it
      splitjoin = {
        mappings = {
          toggle = "gS";
        };
      };

      # Highlight trailing whitespace; :lua MiniTrailspace.trim() to remove
      trailspace = { };
    };
  };
}
