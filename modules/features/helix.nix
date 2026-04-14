{ inputs, self, ... }:
let
  vars = import ./../_config.nix;
in
{
  flake.nixosModules.helix =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.evil-helix
      ];

      hjem.users.${vars.username}.files.".config/helix/config.toml".text = ''
        theme = "rose_pine"

        [editor]
        line-number = "relative"
        cursorline = true
        color-modes = true
        # soft-wrap.enable = true
        # rulers = [80]

        [editor.cursor-shape]
        normal = "block"
        insert = "bar"
        select = "underline"

        [editor.indent-guides]
        render = true
        character = "│"

        [editor.statusline]
        left = ["mode", "spinner", "file-name", "read-only-indicator", "file-modification-indicator"]
        center = []
        right = ["diagnostics", "file-type", "file-encoding", "position"]
        separator = "│"

        [editor.file-picker]
        hidden = false

        # [keys.normal]
        # [keys.insert]
      '';
    };

  perSystem =
    { pkgs, ... }:
    {
      packages.evil-helix = inputs.evil-helix.packages.${pkgs.stdenv.hostPlatform.system}.default;
    };
}
