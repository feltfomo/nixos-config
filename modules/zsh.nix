{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    
    initExtra = ''
      if [[ -z "$FASTFETCH_RAN" ]]; then
        export FASTFETCH_RAN=1
        fastfetch
      fi
    '';
  };
}