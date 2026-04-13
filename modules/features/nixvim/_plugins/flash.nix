{ ... }:
{
  plugins.flash = {
    enable = true;
    settings = {
      labels = "asdfghjklqwertyuiopzxcvbnm";
      search.mode = "fuzzy";
      jump.autojump = false;
      label = {
        uppercase = false;
        rainbow = { enabled = false; shade = 5; };
      };
      modes = {
        # f/F/t/T enhanced with labels when there are multiple matches
        char = {
          enabled = true;
          jump_labels = true;
          multi_line = false;
        };
        # / search enhanced with labels
        search.enabled = true;
      };
    };
  };

  keymaps = [
    # s in normal/visual — flash jump
    {
      mode = [ "n" "x" "o" ];
      key = "s";
      action.__raw = "function() require('flash').jump() end";
      options.desc = "Flash jump";
    }
    # S — treesitter-aware flash (select whole nodes)
    {
      mode = [ "n" "x" "o" ];
      key = "S";
      action.__raw = "function() require('flash').treesitter() end";
      options.desc = "Flash treesitter";
    }
    # r in operator-pending — remote flash (operate on distant location)
    {
      mode = "o";
      key = "r";
      action.__raw = "function() require('flash').remote() end";
      options.desc = "Remote flash";
    }
    # R — treesitter search in operator-pending / visual
    {
      mode = [ "o" "x" ];
      key = "R";
      action.__raw = "function() require('flash').treesitter_search() end";
      options.desc = "Flash treesitter search";
    }
    # <c-s> in command mode — toggle flash search
    {
      mode = "c";
      key = "<c-s>";
      action.__raw = "function() require('flash').toggle() end";
      options.desc = "Toggle flash search";
    }
  ];
}
