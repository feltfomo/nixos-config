{ ... }:
{
  plugins.which-key = {
    enable = true;
    settings = {
      preset = "helix";
      delay = 300;
      win.border = "rounded";
      spec = [
        {
          __unkeyed-1 = "<leader>f";
          group = "find";
        }
        {
          __unkeyed-1 = "<leader>d";
          group = "diagnostics";
        }
        {
          __unkeyed-1 = "<leader>r";
          group = "rename";
        }
        {
          __unkeyed-1 = "<leader>c";
          group = "code";
        }
        {
          __unkeyed-1 = "<leader>t";
          group = "tabs";
        }
        {
          __unkeyed-1 = "<leader>q";
          group = "session";
        }
        {
          __unkeyed-1 = "<leader>R";
          group = "rust";
        }
      ];
    };
  };
}
