{ ... }:
{
  plugins.trouble = {
    enable = true;
    settings = {
      auto_close = false;
      auto_preview = true;
      auto_refresh = true;
      focus = true;
      follow = true;
      modes = {
        lsp_references = {
          params = { include_declaration = true; };
        };
        lsp = {
          win = { position = "right"; };
        };
      };
      icons = {
        indent = {
          fold_open   = " ";
          fold_closed = " ";
          ws          = "  ";
        };
        folder_closed = " ";
        folder_open   = " ";
        kinds = {
          Array         = " ";
          Boolean       = "󰨙 ";
          Class         = " ";
          Constant      = "󰏿 ";
          Constructor   = " ";
          Enum          = " ";
          EnumMember    = " ";
          Event         = " ";
          Field         = " ";
          File          = " ";
          Function      = "󰊕 ";
          Interface     = " ";
          Key           = " ";
          Method        = "󰊕 ";
          Module        = " ";
          Namespace     = "󰦮 ";
          Null          = "󰟢 ";
          Number        = "󰎠 ";
          Object        = " ";
          Operator      = " ";
          Package       = " ";
          Property      = " ";
          String        = " ";
          Struct        = "󰆼 ";
          TypeParameter = " ";
          Variable      = "󰀫 ";
        };
      };
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>xx";
      action = "<cmd>Trouble diagnostics toggle<cr>";
      options.desc = "Diagnostics (Trouble)";
    }
    {
      mode = "n";
      key = "<leader>xX";
      action = "<cmd>Trouble diagnostics toggle filter.buf=0<cr>";
      options.desc = "Buffer diagnostics (Trouble)";
    }
    {
      mode = "n";
      key = "<leader>xL";
      action = "<cmd>Trouble loclist toggle<cr>";
      options.desc = "Location list (Trouble)";
    }
    {
      mode = "n";
      key = "<leader>xQ";
      action = "<cmd>Trouble qflist toggle<cr>";
      options.desc = "Quickfix list (Trouble)";
    }
    {
      mode = "n";
      key = "<leader>xs";
      action = "<cmd>Trouble symbols toggle focus=false<cr>";
      options.desc = "Symbols (Trouble)";
    }
    {
      mode = "n";
      key = "<leader>xr";
      action = "<cmd>Trouble lsp_references toggle focus=false<cr>";
      options.desc = "LSP references (Trouble)";
    }
    # Jump through trouble items without leaving the list
    {
      mode = "n";
      key = "]x";
      action.__raw = ''
        function()
          if require("trouble").is_open() then
            require("trouble").next({ skip_groups = true, jump = true })
          else
            vim.cmd("cnext")
          end
        end
      '';
      options.desc = "Next trouble / quickfix";
    }
    {
      mode = "n";
      key = "[x";
      action.__raw = ''
        function()
          if require("trouble").is_open() then
            require("trouble").prev({ skip_groups = true, jump = true })
          else
            vim.cmd("cprev")
          end
        end
      '';
      options.desc = "Prev trouble / quickfix";
    }
  ];
}
