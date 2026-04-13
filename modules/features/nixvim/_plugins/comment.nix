{ ... }:
{
  plugins.comment-nvim = {
    enable = true;
    settings = {
      # gcc = line comment, gbc = block comment
      # gc{motion} in normal, gc in visual
      toggler = {
        line = "gcc";
        block = "gbc";
      };
      opleader = {
        line = "gc";
        block = "gb";
      };
      extra = {
        above = "gcO"; # add comment line above
        below = "gco"; # add comment line below
        eol = "gcA"; # add comment at end of line
      };
      mappings = {
        basic = true;
        extra = true;
      };
    };
  };
}
