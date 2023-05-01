inputs: _: prev: {
  catppuccin-plymouth = prev.callPackage ./cat-plymouth.nix {};

  sway-hidpi = import ./sway-hidpi.nix inputs prev;
}
