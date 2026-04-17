{ config, pkgs, ... }:
{
  plugins.treesitter = {
    enable = true;
    settings = {
      highlight.enable = true;
      indent.enable = true;
    };
    grammarPackages = (with config.plugins.treesitter.package.builtGrammars; [
      nix
      rust
      lua
      python
      bash
      c
      cpp
      go
      javascript
      typescript
      toml
      json
      yaml
      markdown
      markdown_inline
    ]) ++ [
      pkgs.vimPlugins.nvim-treesitter.builtGrammars.pkl
    ];
  };

  # nvim-treesitter source needed for pkl query files (highlights/folds/injections)
  # the grammar .so alone is not enough — queries must be on runtimepath
  extraPlugins = [ pkgs.vimPlugins.nvim-treesitter ];
}
