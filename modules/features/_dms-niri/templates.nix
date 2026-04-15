{ ... }:
let
  vars = import ./../../_config.nix;
in
{
  imports = [
    ./_templates/kitty-colors.nix
    ./_templates/niri-colors.nix
    ./_templates/nvim-colors.nix
    ./_templates/lualine-colors.nix
  ];

  hjem.users.${vars.username}.files = {
    ".config/matugen/config.toml".text = ''
      [config]

      [templates.kitty-dms-colors]
      input_path = '/home/${vars.username}/.config/matugen/templates/kitty-dms-colors.conf'
      output_path = '/home/${vars.username}/.config/kitty/dms-colors.conf'
      post_hook = "/run/current-system/sw/bin/pkill -USR1 kitty 2>/dev/null; true"

      [templates.niri-dms-colors]
      input_path = '/home/${vars.username}/.config/matugen/templates/niri-dms-colors.kdl'
      output_path = '/home/${vars.username}/.config/niri/dms-colors.kdl'
      post_hook = "true"

      [templates.lualine-dms-colors]
      input_path = '/home/${vars.username}/.config/matugen/templates/lualine-dms-colors.lua'
      output_path = '/home/${vars.username}/.config/nvim/lualine-dms-colors.lua'
      post_hook = "bash -c 'for f in /run/user/$(id -u)/nvim.*.0; do nvim --server \"$f\" --remote-send \"<cmd>source ~/.config/nvim/lualine-dms-colors.lua<cr>\" 2>/dev/null; done; true'"

      [templates.nvim-dms-colors]
      input_path = '/home/${vars.username}/.config/matugen/templates/nvim-dms-colors.lua'
      output_path = '/home/${vars.username}/.config/nvim/nvim-dms-colors.lua'
      post_hook = "bash -c 'for f in /run/user/$(id -u)/nvim.*.0; do nvim --server \"$f\" --remote-send \"<cmd>source ~/.config/nvim/nvim-dms-colors.lua<cr>\" 2>/dev/null; done; true'"
    '';
  };
}
