{ self, ... }: {
  flake.nixosModules.mcsr = { pkgs, ... }: {
    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.mcsrLauncher
    ];
  };

  perSystem = { pkgs, ... }: {
    packages.mcsrLauncher = pkgs.callPackage ./_mcsr-pkg.nix {};
  };
}
