{ pkgs, ... }:
let
  tabby-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "tabby-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "nanozuki";
      repo = "tabby.nvim";
      rev = "main";
      hash = "sha256-YAnw/FpSLqKjvnug4bdvbGHpYWwtDKuh/DmxhK+PSu0=";
    };
  };
in
{
  extraPlugins = [ tabby-nvim ];

  extraConfigLuaPost = ''
    local theme = {
      fill        = "TabLineFill",
      head        = "TabLine",
      current_tab = { fg = "#191724", bg = "#c4a7e7", style = "italic" },
      tab         = "TabLine",
    }

    require("tabby.tabline").set(function(line)
      return {
        {
          { "  ", hl = theme.head },
          line.sep("", theme.head, theme.fill),
        },
        line.tabs().foreach(function(tab)
          local hl = tab.is_current() and theme.current_tab or theme.tab
          return {
            line.sep("", hl, theme.fill),
            tab.is_current() and "" or "󰆣",
            tab.number(),
            tab.name(),
            line.sep("", hl, theme.fill),
            hl = hl,
            margin = " ",
          }
        end),
        line.spacer(),
        hl = theme.fill,
      }
    end)
  '';

  keymaps = [
    {
      mode = "n";
      key = "<leader>ta";
      action = ":$tabnew<CR>";
      options.desc = "New tab";
    }
    {
      mode = "n";
      key = "<leader>tc";
      action = ":tabclose<CR>";
      options.desc = "Close tab";
    }
    {
      mode = "n";
      key = "<leader>tn";
      action = ":tabn<CR>";
      options.desc = "Next tab";
    }
    {
      mode = "n";
      key = "<leader>tp";
      action = ":tabp<CR>";
      options.desc = "Prev tab";
    }
  ];
}
