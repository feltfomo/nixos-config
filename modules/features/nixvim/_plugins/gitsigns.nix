{ ... }:
{
  plugins.gitsigns = {
    enable = true;
    settings = {
      current_line_blame = true;
      current_line_blame_opts = {
        virt_text = true;
        virt_text_pos = "eol";
        delay = 500;
      };
      signs = {
        add = { text = "▎"; };
        change = { text = "▎"; };
        delete = { text = ""; };
        topdelete = { text = ""; };
        changedelete = { text = "▎"; };
        untracked = { text = "▎"; };
      };
    };
  };

  keymaps = [
    # Hunk navigation
    {
      mode = "n";
      key = "]h";
      action.__raw = "function() require('gitsigns').next_hunk() end";
      options.desc = "Next hunk";
    }
    {
      mode = "n";
      key = "[h";
      action.__raw = "function() require('gitsigns').prev_hunk() end";
      options.desc = "Prev hunk";
    }
    # Stage / reset
    {
      mode = [ "n" "v" ];
      key = "<leader>gs";
      action.__raw = "function() require('gitsigns').stage_hunk() end";
      options.desc = "Stage hunk";
    }
    {
      mode = [ "n" "v" ];
      key = "<leader>gr";
      action.__raw = "function() require('gitsigns').reset_hunk() end";
      options.desc = "Reset hunk";
    }
    {
      mode = "n";
      key = "<leader>gS";
      action.__raw = "function() require('gitsigns').stage_buffer() end";
      options.desc = "Stage buffer";
    }
    {
      mode = "n";
      key = "<leader>gR";
      action.__raw = "function() require('gitsigns').reset_buffer() end";
      options.desc = "Reset buffer";
    }
    {
      mode = "n";
      key = "<leader>gu";
      action.__raw = "function() require('gitsigns').undo_stage_hunk() end";
      options.desc = "Undo stage hunk";
    }
    # Preview / blame
    {
      mode = "n";
      key = "<leader>gp";
      action.__raw = "function() require('gitsigns').preview_hunk() end";
      options.desc = "Preview hunk";
    }
    {
      mode = "n";
      key = "<leader>gb";
      action.__raw = "function() require('gitsigns').blame_line({ full = true }) end";
      options.desc = "Blame line (full)";
    }
    {
      mode = "n";
      key = "<leader>gB";
      action.__raw = "function() require('gitsigns').toggle_current_line_blame() end";
      options.desc = "Toggle inline blame";
    }
    # Diff
    {
      mode = "n";
      key = "<leader>gd";
      action.__raw = "function() require('gitsigns').diffthis() end";
      options.desc = "Diff this";
    }
    # Text object — select hunk
    {
      mode = [ "o" "x" ];
      key = "ih";
      action = ":<c-u>Gitsigns select_hunk<cr>";
      options.desc = "Select hunk";
    }
  ];
}
