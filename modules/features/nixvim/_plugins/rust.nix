{ ... }:
{
  plugins.rustaceanvim = {
    enable = true;
    settings.server.default_settings = {
      "rust-analyzer" = {
        cargo.allFeatures = true;
        checkOnSave.command = "clippy";
        inlayHints = {
          bindingModeHints.enable = true;
          closureCaptureHints.enable = true;
          expressionAdjustmentHints.enable = true;
          lifetimeElisionHints.enable = true;
        };
      };
    };
  };

  plugins.crates = {
    enable = true;
    settings.completion.crates.enabled = true;
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>Rr";
      action = "<cmd>RustLsp runnables<cr>";
      options.desc = "Rust runnables";
    }
    {
      mode = "n";
      key = "<leader>Rt";
      action = "<cmd>RustLsp testables<cr>";
      options.desc = "Rust testables";
    }
    {
      mode = "n";
      key = "<leader>Re";
      action = "<cmd>RustLsp expandMacro<cr>";
      options.desc = "Expand macro";
    }
    {
      mode = "n";
      key = "<leader>Rc";
      action = "<cmd>RustLsp openCargo<cr>";
      options.desc = "Open Cargo.toml";
    }
  ];
}
