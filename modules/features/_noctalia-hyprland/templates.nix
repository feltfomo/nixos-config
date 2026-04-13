{ ... }:
let
  vars = import ./../../_config.nix;
in
{
  imports = [
    ./_templates/kitty-colors.nix
    ./_templates/hyprland-colors.nix
    ./_templates/zed-theme.nix
    ./_templates/foot-colors.nix
    ./_templates/satty.nix
    ./_templates/nvim-colors.nix
    ./_templates/lualine-colors.nix
    ./_templates/ghostty-colors.nix
  ];

  hjem.users.${vars.username}.files = {
    ".config-hyprland/noctalia/user-templates.toml".text = ''
      [config]

      [templates.kitty]
      input_path = "~/.config-hyprland/noctalia/templates/kitty-colors.conf"
      output_path = "~/.config/kitty/noctalia-colors.conf"
      post_hook = "kill -USR1 $(pidof kitty) 2>/dev/null; true"

      [templates.hyprland]
      input_path = "~/.config-hyprland/noctalia/templates/hyprland-colors.conf"
      output_path = "~/.config/hypr/noctalia-colors.conf"
      post_hook = "hyprctl reload 2>/dev/null; true"

      [templates.zed]
      input_path = "~/.config-hyprland/noctalia/templates/zed-theme.json"
      output_path = "~/.config/zed/themes/noctalia.json"
      post_hook = "true"

      [templates.satty]
      input_path = "~/.config-hyprland/noctalia/templates/satty.css"
      output_path = "~/.config/satty/overrides.css"
      post_hook = "true"

      [templates.nvim]
      input_path = "~/.config-hyprland/noctalia/templates/nvim-colors.lua"
      output_path = "~/.config/nvim/noctalia-colors.lua"
      post_hook = "nvim --server /tmp/nvim.sock --remote-send '<cmd>source ~/.config/nvim/noctalia-colors.lua<cr>' 2>/dev/null; true"

      [templates.lualine]
      input_path = "~/.config-hyprland/noctalia/templates/lualine-colors.lua"
      output_path = "~/.config/nvim/lualine-colors.lua"
      post_hook = "nvim --server /tmp/nvim.sock --remote-send '<cmd>source ~/.config/nvim/lualine-colors.lua<cr>' 2>/dev/null; true"

      [templates.foot]
      input_path = "~/.config-hyprland/noctalia/templates/foot-colors.ini"
      output_path = "~/.config/foot/noctalia-colors.ini"
      post_hook = "true"

      [templates.ghostty]
      input_path = "~/.config-hyprland/noctalia/templates/ghostty-colors"
      output_path = "~/.config/ghostty/noctalia-colors"
      post_hook = "true"
    '';
  };
}
