{ ... }: {
  perSystem = { pkgs, ... }: {
    devShells.rust = pkgs.mkShell {
      packages = with pkgs; [
        rustup
        pkg-config
        openssl
        gcc
        gdb
        lldb
        cargo-watch
        cargo-expand
        cargo-edit
        cargo-audit
        bacon
        eza
        uutils-coreutils-noprefix
        ripgrep
        fd
        bat
        zoxide
        mprocs
        fastfetch
        fish
      ];
      shellHook = ''
        rustup default stable
        rustup component add rust-analyzer rust-src clippy rustfmt

        export SHELL="${pkgs.fish}/bin/fish"
        exec ${pkgs.fish}/bin/fish
      '';
    };
  };
}
