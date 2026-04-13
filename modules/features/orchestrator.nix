{ self, ... }:
{
  flake.nixosModules.orchestrator = { pkgs, ... }: {
    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.fomonix
    ];
  };

  perSystem = { pkgs, ... }: {
    packages.fomonix = pkgs.rustPlatform.buildRustPackage {
      pname = "fomonix";
      version = "0.1.0";
      src = ./../../tools/orchestrator;
      cargoLock.lockFile = ./../../tools/orchestrator/Cargo.lock;
    };

    devShells.fomonix = pkgs.mkShell {
      name = "fomonix-dev";
      packages = with pkgs; [
        rustc
        cargo
        rust-analyzer
        clippy
        rustfmt
      ];
      shellHook = ''
        echo ""
        echo "  fomonix dev shell"
        echo "  rust: $(rustc --version)"
        echo ""
      '';
    };
  };
}
