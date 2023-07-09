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
    nix-index-database.nixosModules.nix-index
    envfs.nixosModules.envfs
    ../modules/booting.nix
    ../modules/security.nix
    ../modules/compat.nix
    ../modules/network
    ../modules/nix-daemon.nix
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
    ../modules/firefox.nix
    aagl.nixosModules.default
    chaotic.nixosModules.default
  ];
  specialArgs = nixosExtraSpecialArgs;
in {
  envious = nixosSystem {
    modules =
      [
        ./envious
        inputs.lanzaboote.nixosModules.lanzaboote
        {home-manager.users.yavor.imports = homeImports."yavor@envious";}
      ]
      ++ sharedModules
      ++ graphicalModules;
    system = "x86_64-linux";
    inherit specialArgs;
  };
}
