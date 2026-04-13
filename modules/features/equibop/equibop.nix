{ self, ... }: {
  flake.nixosModules.equibop = { pkgs, ... }: {
    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.myEquibop
    ];
  };

  perSystem = { pkgs, ... }: {
    packages.myEquibop = pkgs.callPackage ./_equibop-pkg.nix {};
  };
}
