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

  # niri: reactive DMS matugen colors
  flake.nixosModules.nixvimNiri = {
    programs.nixvim.extraConfigLuaPre = ''
      local function safe_dofile(path)
        local expanded = vim.fn.expand(path)
        if vim.fn.filereadable(expanded) == 1 then
          dofile(expanded)
        end
      end

      safe_dofile("~/.config/nvim/nvim-dms-colors.lua")
      safe_dofile("~/.config/nvim/lualine-dms-colors.lua")
    '';
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
