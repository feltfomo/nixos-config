{ ... }:
{
  plugins.lsp = {
    enable = true;
    servers = {
      nixd.enable = true;
      taplo.enable = true;
      jsonls.enable = true;
      yamlls.enable = true;
      marksman.enable = true;
    };
    keymaps = {
      diagnostic = {
        "[d" = {
          action = "goto_prev";
          desc = "Prev diagnostic";
        };
        "]d" = {
          action = "goto_next";
          desc = "Next diagnostic";
        };
      };
      lspBuf = {
        "gd" = {
          action = "definition";
          desc = "Go to definition";
        };
        "gr" = {
          action = "references";
          desc = "Go to references";
        };
        "K" = {
          action = "hover";
          desc = "Hover docs";
        };
        "<leader>rn" = {
          action = "rename";
          desc = "Rename";
        };
        "<leader>ca" = {
          action = "code_action";
          desc = "Code action";
        };
      };
    };
  };
}
