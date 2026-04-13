{ ... }:
{
  plugins.neotest = {
    enable = true;
    settings = {
      # adapters are registered here — add neotest-rust etc. as extraPlugins
      # and register them via adapters when you need language support
      output.open_on_run = true;
      status.virtual_text = true;
      icons = {
        running_animated = [
          "⠋"
          "⠙"
          "⠹"
          "⠸"
          "⠼"
          "⠴"
          "⠦"
          "⠧"
          "⠇"
          "⠏"
        ];
      };
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>tt";
      action.__raw = "function() require('neotest').run.run() end";
      options.desc = "Run nearest test";
    }
    {
      mode = "n";
      key = "<leader>tf";
      action.__raw = "function() require('neotest').run.run(vim.fn.expand('%')) end";
      options.desc = "Run file tests";
    }
    {
      mode = "n";
      key = "<leader>ts";
      action.__raw = "function() require('neotest').run.stop() end";
      options.desc = "Stop test";
    }
    {
      mode = "n";
      key = "<leader>ta";
      action.__raw = "function() require('neotest').run.run(vim.fn.getcwd()) end";
      options.desc = "Run all tests";
    }
    {
      mode = "n";
      key = "<leader>to";
      action.__raw = "function() require('neotest').output.open({ enter = true }) end";
      options.desc = "Test output";
    }
    {
      mode = "n";
      key = "<leader>tO";
      action.__raw = "function() require('neotest').output_panel.toggle() end";
      options.desc = "Toggle output panel";
    }
    {
      mode = "n";
      key = "<leader>tS";
      action.__raw = "function() require('neotest').summary.toggle() end";
      options.desc = "Toggle summary";
    }
    {
      mode = "n";
      key = "]t";
      action.__raw = "function() require('neotest').jump.next({ status = 'failed' }) end";
      options.desc = "Next failed test";
    }
    {
      mode = "n";
      key = "[t";
      action.__raw = "function() require('neotest').jump.prev({ status = 'failed' }) end";
      options.desc = "Prev failed test";
    }
  ];
}
