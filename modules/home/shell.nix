{ config, pkgs, ... }:
{
  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      initContent = ''
        # Fastfetch on startup
        fastfetch

        # Zoxide initialization
        eval "$(zoxide init zsh)"

        # Atuin initialization
        eval "$(atuin init zsh)"
      '';

      shellAliases = {
        # Modern replacements
        ls = "eza --icons --group-directories-first";
        ll = "eza -l --icons --group-directories-first";
        la = "eza -la --icons --group-directories-first";
        lt = "eza --tree --icons --group-directories-first";
        cat = "bat --style=auto";
        cd = "z";
        
        # Git shortcuts
        gs = "git status";
        ga = "git add";
        gc = "git commit";
        gp = "git push";
        
        # NixOS shortcuts
        update = "sudo nixos-rebuild switch --flake /etc/nixos#fomonix";
        clean = "sudo nix-collect-garbage -d";
        
        # System
        top = "btop";
        du = "dust";
        df = "duf";
      };

      history = {
        size = 10000;
        path = "${config.xdg.dataHome}/zsh/history";
      };
    };

    # Atuin config
    atuin = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        auto_sync = false;
        update_check = false;
        style = "compact";
        inline_height = 20;
      };
    };

    # Zoxide config
    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    # Eza config
    eza = {
      enable = true;
      enableZshIntegration = true;
      icons = "auto";
      git = true;
    };

    # Bat config
    bat = {
      enable = true;
      config = {
        theme = "Catppuccin Mocha";
        style = "numbers,changes,header";
      };
    };

    # FZF config
    fzf = {
      enable = true;
      enableZshIntegration = true;
      colors = {
        bg = "#1e1e2e";
        "bg+" = "#313244";
        fg = "#cdd6f4";
        "fg+" = "#cdd6f4";
        hl = "#f38ba8";
        "hl+" = "#f38ba8";
      };
    };
  };
}