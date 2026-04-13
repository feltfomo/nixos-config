{ ... }:
{
  plugins.snacks = {
    enable = true;
    settings = {
      notifier.enabled = true;
      indent.enabled = true;
      words.enabled = true;
      scroll.enabled = true;
    };
  };

  extraConfigLua = ''
    vim.notify = require("snacks").notify
  '';
}
