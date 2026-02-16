{ ... }:
{
  nixpkgs.overlays = [
    (final: prev: {
      ckb-next = prev.ckb-next.overrideAttrs (old: {
        cmakeFlags = (old.cmakeFlags or [ ]) ++ [
          "-DUSE_DBUS_MENU=0"
        ];
      });

      warp-terminal = prev.warp-terminal.overrideAttrs (old: {
        buildInputs = (old.buildInputs or [ ]) ++ [ prev.xz ];
        src = prev.fetchurl {
          url = "https://app.warp.dev/download?package=pacman";
          name = "warp-terminal.pkg.tar.zst";
          hash = "sha256-LzkByYibCwJbX9KaihoLOqW7oqtrjyojJojjmrQ9Y1o=";
        };
      });
    })
  ];
}
