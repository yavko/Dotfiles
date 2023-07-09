inputs: _: prev: {
  sway-hidpi = import ./sway-hidpi.nix inputs prev;
  open-utau = prev.callPackage ./open-utau {};
}
