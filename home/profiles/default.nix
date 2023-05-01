self: {
  hm,
  nixpkgs,
  ...
} @ inputs: let
  inherit (self) lib;
  sharedModules = [
    inputs.nix-colors.homeManagerModule
    inputs.nix-index-database.hmModules.nix-index
    ../../secrets/home.nix
    ../../home.nix
  ];
  graphicalModules = with inputs; [
    hyprland.homeManagerModules.default
    ironbar.homeManagerModules.default
    hpr_scratcher.homeManagerModules.default
    hy3.homeManagerModules.default
  ];
  homeImports = {
    "yavor@envious" = sharedModules ++ graphicalModules ++ [./envious/yavor.nix];
  };
  extraSpecialArgs = lib.hmExtraSpecialArgs;
in {
  inherit homeImports extraSpecialArgs;
  homeConfigurations = {
    "yavor@envious" = hm.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      modules = homeImports."yavor@envious";
      extraSpecialArgs = lib.mkExtraSpecialArgs {};
    };
  };
}
