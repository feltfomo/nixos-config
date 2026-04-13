{ ... }:
{
  plugins.grug-far = {
    enable = true;
    settings = {
      windowCreationCommand = "vsplit";
      keymaps = {
        replace      = { n = "<localleader>r"; };
        qflist       = { n = "<localleader>q"; };
        syncLocations= { n = "<localleader>s"; };
        abort        = { n = "<localleader>a"; };
        historyOpen  = { n = "<localleader>h"; };
        close        = { n = "<localleader>c"; };
      };
    };
  };

  keymaps = [
    {
      mode = [ "n" "v" ];
      key = "<leader>sr";
      action = "<cmd>GrugFar<cr>";
      options.desc = "Search & replace (grug-far)";
    }
    {
      mode = "n";
      key = "<leader>sR";
      action.__raw = ''
        function()
          require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } })
        end
      '';
      options.desc = "Search & replace word under cursor";
    }
    {
      mode = "v";
      key = "<leader>sR";
      action.__raw = ''
        function()
          require("grug-far").with_visual_selection({})
        end
      '';
      options.desc = "Search & replace selection";
    }
  ];
}
