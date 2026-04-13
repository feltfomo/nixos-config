{ ... }:
{
  flake.nixosModules.nixvim = {
    programs.nixvim = {
      enable = true;
      defaultEditor = true;

      imports = [
        ./_plugins/treesitter.nix
        ./_plugins/telescope.nix
        ./_plugins/lsp.nix
        ./_plugins/which-key.nix
        ./_plugins/oil.nix
        ./_plugins/snacks.nix
        ./_plugins/noice.nix
        ./_plugins/blink.nix
        ./_plugins/tabby.nix
        ./_plugins/lualine.nix
        ./_plugins/persistence.nix
        ./_plugins/rust.nix
        ./_plugins/conform.nix
        ./_plugins/lazygit.nix
        ./_plugins/gitsigns.nix
        ./_plugins/diffview.nix
        ./_plugins/dap.nix
        ./_plugins/neotest.nix
        ./_plugins/surround.nix
        ./_plugins/mini.nix
        ./_plugins/comment.nix
        ./_plugins/flash.nix
        ./_plugins/multicursors.nix
        ./_plugins/harpoon.nix
        ./_plugins/grug-far.nix
        ./_plugins/trouble.nix
        ./_plugins/aerial.nix
        ./_plugins/keymaps.nix
      ];

      globals.mapleader = " ";

      opts = {
        number = true;
        relativenumber = true;
        signcolumn = "yes";
        scrolloff = 8;
        tabstop = 2;
        shiftwidth = 2;
        expandtab = true;
        termguicolors = true;
        clipboard = "unnamedplus";
      };
    };
  };

  # niri: static rose-pine
  flake.nixosModules.nixvimNiri = {
    programs.nixvim = {
      colorschemes.rose-pine = {
        enable = true;
        settings.variant = "main";
      };
      plugins.lualine.settings.options.theme = {
        normal = {
          a = {
            fg = "#191724";
            bg = "#31748f";
            gui = "bold";
          };
          b = {
            fg = "#e0def4";
            bg = "#26233a";
          };
          c = {
            fg = "#e0def4";
            bg = "#191724";
          };
        };
        insert = {
          a = {
            fg = "#191724";
            bg = "#9ccfd8";
            gui = "bold";
          };
          b = {
            fg = "#e0def4";
            bg = "#26233a";
          };
          c = {
            fg = "#e0def4";
            bg = "#191724";
          };
        };
        visual = {
          a = {
            fg = "#191724";
            bg = "#c4a7e7";
            gui = "bold";
          };
          b = {
            fg = "#e0def4";
            bg = "#26233a";
          };
          c = {
            fg = "#e0def4";
            bg = "#191724";
          };
        };
        replace = {
          a = {
            fg = "#191724";
            bg = "#eb6f92";
            gui = "bold";
          };
          b = {
            fg = "#e0def4";
            bg = "#26233a";
          };
          c = {
            fg = "#e0def4";
            bg = "#191724";
          };
        };
        inactive = {
          a = {
            fg = "#6e6a86";
            bg = "#191724";
          };
          b = {
            fg = "#6e6a86";
            bg = "#191724";
          };
          c = {
            fg = "#6e6a86";
            bg = "#191724";
          };
        };
      };
    };
  };

  # hyprland: matugen reactive
  flake.nixosModules.nixvimHyprland = {
    programs.nixvim.extraConfigLuaPre = ''
      local colors_file = vim.fn.expand("~/.config/nvim/noctalia-colors.lua")
      if vim.fn.filereadable(colors_file) == 1 then
        dofile(colors_file)
      end
      local lualine_file = vim.fn.expand("~/.config/nvim/lualine-colors.lua")
      if vim.fn.filereadable(lualine_file) == 1 then
        dofile(lualine_file)
      end
    '';
  };
}
