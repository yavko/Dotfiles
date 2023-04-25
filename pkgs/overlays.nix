inputs: _: prev: {
  catppuccin-plymouth = prev.callPackage ./catppuccin-plymouth.nix {};

  #sway-hidpi = import ./sway-hidpi.nix inputs prev;
}
