{ ... }:
{
  plugins.dap.enable = true;

  plugins.dap-ui = {
    enable = true;
    settings = {
      layouts = [
        {
          elements = [
            { id = "scopes"; size = 0.4; }
            { id = "breakpoints"; size = 0.2; }
            { id = "stacks"; size = 0.2; }
            { id = "watches"; size = 0.2; }
          ];
          position = "left";
          size = 40;
        }
        {
          elements = [
            { id = "repl"; size = 0.5; }
            { id = "console"; size = 0.5; }
          ];
          position = "bottom";
          size = 10;
        }
      ];
      floating = {
        max_height = 0.9;
        max_width = 0.9;
        border = "rounded";
      };
    };
  };

  plugins.dap-virtual-text = {
    enable = true;
    settings = {
      enabled = true;
      enabled_commands = true;
      highlight_changed_variables = true;
      highlight_new_as_changed = true;
      show_stop_reason = true;
      commented = false;
      only_first_definition = true;
      all_references = false;
      clear_on_continue = false;
    };
  };

  # Open/close dap-ui automatically when debug session starts/ends
  extraConfigLua = ''
    local dap, dapui = require("dap"), require("dapui")
    dap.listeners.before.attach.dapui_config = function() dapui.open() end
    dap.listeners.before.launch.dapui_config = function() dapui.open() end
    dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
    dap.listeners.before.event_exited.dapui_config = function() dapui.close() end

    -- Better breakpoint sign
    vim.fn.sign_define("DapBreakpoint",          { text = "●", texthl = "DiagnosticError",   linehl = "", numhl = "" })
    vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarning", linehl = "", numhl = "" })
    vim.fn.sign_define("DapLogPoint",            { text = "◎", texthl = "DiagnosticInfo",    linehl = "", numhl = "" })
    vim.fn.sign_define("DapStopped",             { text = "▶", texthl = "DiagnosticOk",      linehl = "DiffAdd",    numhl = "" })
    vim.fn.sign_define("DapBreakpointRejected",  { text = "✕", texthl = "DiagnosticHint",    linehl = "", numhl = "" })
  '';

  keymaps = [
    # Session control
    {
      mode = "n";
      key = "<leader>dc";
      action.__raw = "function() require('dap').continue() end";
      options.desc = "Continue / Start";
    }
    {
      mode = "n";
      key = "<leader>dq";
      action.__raw = "function() require('dap').terminate() end";
      options.desc = "Terminate session";
    }
    {
      mode = "n";
      key = "<leader>dr";
      action.__raw = "function() require('dap').restart() end";
      options.desc = "Restart session";
    }

    # Stepping
    {
      mode = "n";
      key = "<leader>dn";
      action.__raw = "function() require('dap').step_over() end";
      options.desc = "Step over";
    }
    {
      mode = "n";
      key = "<leader>di";
      action.__raw = "function() require('dap').step_into() end";
      options.desc = "Step into";
    }
    {
      mode = "n";
      key = "<leader>do";
      action.__raw = "function() require('dap').step_out() end";
      options.desc = "Step out";
    }
    {
      mode = "n";
      key = "<leader>dC";
      action.__raw = "function() require('dap').run_to_cursor() end";
      options.desc = "Run to cursor";
    }

    # Breakpoints
    {
      mode = "n";
      key = "<leader>db";
      action.__raw = "function() require('dap').toggle_breakpoint() end";
      options.desc = "Toggle breakpoint";
    }
    {
      mode = "n";
      key = "<leader>dB";
      action.__raw = "function() require('dap').set_breakpoint(vim.fn.input('Condition: ')) end";
      options.desc = "Conditional breakpoint";
    }
    {
      mode = "n";
      key = "<leader>dl";
      action.__raw = "function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log message: ')) end";
      options.desc = "Log point";
    }
    {
      mode = "n";
      key = "<leader>dL";
      action.__raw = "function() require('dap').list_breakpoints() end";
      options.desc = "List breakpoints";
    }
    {
      mode = "n";
      key = "<leader>dx";
      action.__raw = "function() require('dap').clear_breakpoints() end";
      options.desc = "Clear all breakpoints";
    }

    # UI
    {
      mode = "n";
      key = "<leader>du";
      action.__raw = "function() require('dapui').toggle() end";
      options.desc = "Toggle DAP UI";
    }
    {
      mode = "n";
      key = "<leader>de";
      action.__raw = "function() require('dapui').eval() end";
      options.desc = "Eval expression";
    }
    {
      mode = "v";
      key = "<leader>de";
      action.__raw = "function() require('dapui').eval() end";
      options.desc = "Eval selection";
    }

    # REPL
    {
      mode = "n";
      key = "<leader>dR";
      action.__raw = "function() require('dap').repl.open() end";
      options.desc = "Open REPL";
    }
  ];
}
