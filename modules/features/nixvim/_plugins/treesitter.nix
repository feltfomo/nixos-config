{ config, ... }:
{
  plugins.treesitter = {
    enable = true;
    settings = {
      highlight.enable = true;
      indent.enable = true;
    };
    grammarPackages = with config.plugins.treesitter.package.builtGrammars; [
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
    ];
  };
}
