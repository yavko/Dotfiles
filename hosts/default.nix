inputs: let
  inherit (inputs) self;
  inherit (self.lib) nixosSystem nixosExtraSpecialArgs hmExtraSpecialArgs nixpkgsConfig;
  inherit (import "${self}/home/profiles" self inputs) homeImports;

  sharedModules = with inputs; [
    {
      _module.args = {
        inherit inputs;
        inherit (self.lib) default;
      };
    }
    hm.nixosModule
    agenix.nixosModules.default
    nur.nixosModules.nur
    {
      home-manager = {
        useGlobalPkgs = true;
        extraSpecialArgs = hmExtraSpecialArgs;
      };
    }
    nixpkgsConfig
  ];
  graphicalModules = with inputs; [
    hyprland.nixosModules.default
    ../modules/fonts.nix
    ../modules/greetd.nix
    aagl.nixosModules.default
  ];
  specialArgs = nixosExtraSpecialArgs;
in {
  envious = nixosSystem {
    modules =
      [
        ./envious
        {home-manager.users.yavor.imports = homeImports."yavor@envious";}
      ]
      ++ sharedModules
      ++ graphicalModules;
    system = "x86_64-linux";
    inherit specialArgs;
  };
}
