{ ... }:
{
  plugins.conform-nvim = {
    enable = true;
    settings = {
      formatters_by_ft = {
        nix = [ "nixfmt" ];
        rust = [ "rustfmt" ];
        lua = [ "stylua" ];
        json = [ "jq" ];
      };
      format_on_save = {
        timeout_ms = 500;
        lsp_fallback = true;
      };
    };
  };

  keymaps = [
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>cf";
      action.__raw = ''function() require("conform").format({ async = true, lsp_fallback = true }) end'';
      options.desc = "Format file";
    }
  ];
}
