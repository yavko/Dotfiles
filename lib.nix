inputs: let
  inherit (inputs.nixpkgs) lib;
  inherit (inputs) self;
  slib = inputs.nix-std.lib;
  defaultArgs = {
    inherit inputs;
    inherit (inputs) nix-colors;
  };
  mkExtraSpecialArgs = args: (defaultArgs // args);
  substituters = {
    urls = [
      "https://nrdxp.cachix.org"
      "https://hyprland.cachix.org"
      "https://nix-community.cachix.org"
      "https://helix.cachix.org"
      "https://prismlauncher.cachix.org"
      "https://jakestanger.cachix.org" # ironbar
      "https://ezkea.cachix.org" # for aagl (if you know, you know)
    ];
    keys = [
      "nrdxp.cachix.org-1:Fc5PSqY2Jm1TrWfm88l6cvGWwz3s93c6IOifQWnhNW4="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
      "prismlauncher.cachix.org-1:GhJfjdP1RFKtFSH3gXTIQCvZwsb2cioisOf91y/bK0w="
      "jakestanger.cachix.org-1:VWJE7AWNe5/KOEvCQRxoE8UsI2Xs2nHULJ7TEjYm7mM=" # ironbar
      "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI=" # aagl (if you know, you know)
    ];
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
        alejandra.overlay
        nil.overlays.default
      ];
      nixpkgs.config.allowUnfreePredicate = pkg: true;
      nixpkgs.config = {
        allowUnfree = true;
      };
    };
  }
