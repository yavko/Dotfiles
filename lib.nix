inputs: let
  inherit (inputs.nixpkgs) lib;
  inherit (inputs) self;
  slib = inputs.nix-std.lib;
  defaultArgs = {
    inherit inputs;
    inherit (inputs) nix-colors;
  };
  mkExtraSpecialArgs = args: (defaultArgs // args);
  substituters = let
    nConf = (import ./flake.nix).nixConfig;
  in {
    urls = nConf.extra-substituters;
    keys = nConf.extra-trusted-public-keys;
  };
in
  slib
  // lib
  // {
    inherit mkExtraSpecialArgs substituters;
    nixosExtraSpecialArgs = mkExtraSpecialArgs {
      inherit (self) lib;
    };
    hmExtraSpecialArgs = mkExtraSpecialArgs {
      std = slib;
    };
    genSystems = lib.genAttrs ["x86_64-linux"];
    nixpkgsConfig = {...}: {
      nixpkgs.overlays = with inputs; [
        rust-overlay.overlays.default
        hyprpicker.overlays.default
        hyprpaper.overlays.default
        hyprland-contrib.overlays.default
        hyprland.overlays.default
        #aagl.overlays.default
        #neovim-nightly-overlay.overlay
        #prismlauncher.overlay
        #hpr_scratcher.overlay.default
        anyrun.overlay
        alejandra.overlay
        nil.overlays.default
      ];
      nixpkgs.config.allowUnfreePredicate = pkg: true;
      nixpkgs.config = {
        allowUnfree = true;
      };
    };
  }
