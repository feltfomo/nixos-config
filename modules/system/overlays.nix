{ ... }:
{
  nixpkgs.overlays = [
    (final: prev: {
      ckb-next = prev.ckb-next.overrideAttrs (old: {
        cmakeFlags = (old.cmakeFlags or []) ++ [
          "-DUSE_DBUS_MENU=0"
        ];
      });
    })
  ];
}
