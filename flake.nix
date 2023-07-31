{
  description = "Yavko's Dotfiles";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    nix-super.url = "github:privatevoid-net/nix-super";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    hm = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impurity.url = "github:outfoxxed/impurity.nix";
    wrapper-manager = {
      url = "github:viperML/wrapper-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix.url = "github:yaxitech/ragenix";
    hyprland.url = "github:hyprwm/Hyprland/"; #2cbb10d850f0860fcb1c940ebc047c7c4deb9e91";
    helix.url = "github:helix-editor/helix";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    neovim-flake = {
      url = "github:notashelf/neovim-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    prismlauncher.url = "github:PrismLauncher/PrismLauncher";
    nix-colors.url = "github:Misterio77/nix-colors";
    #fu.url = "github:numtide/flake-utils";
    nix-std.url = "github:chessai/nix-std";
    nur.url = "github:nix-community/NUR";
    alejandra.url = "github:kamadorueda/alejandra/3.0.0";
    alejandra.inputs.nixpkgs.follows = "nixpkgs";
    eww = {
      url = "github:elkowar/eww";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rust-overlay.follows = "rust-overlay";
    };
    aagl.url = "github:ezKEa/aagl-gtk-on-nix";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
      #  inputs.flake-utils.follows = "fu";
    };
    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprpaper = {
      url = "github:hyprwm/hyprpaper";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprpicker = {
      url = "github:hyprwm/hyprpicker";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nil = {
      url = "github:oxalica/nil";
      inputs.nixpkgs.follows = "nixpkgs";
      #inputs.flake-utils.follows = "fu";
      inputs.rust-overlay.follows = "rust-overlay";
    };
    nixd = {
      url = "github:nix-community/nixd";
    };
    devshell.url = "github:numtide/devshell";
    ironbar = {
      url = "github:JakeStanger/ironbar/";
      #inputs.nixpkgs.follows = "nixpkgs";
      #inputs.rust-overlay.follows = "rust-overlay";
    };
    anyrun = {
      url = "github:Kirottu/anyrun";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hpr_scratcher = {
      #url = "github:yavko/hpr_scratcher";
      url = "/home/yavor/Projects/External/hpr-scratcher/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hy3 = {
      url = "github:outfoxxed/hy3";
      inputs.hyprland.follows = "hyprland";
    };
    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    nix-alien.url = "github:thiagokokada/nix-alien";
    envfs.url = "github:Mic92/envfs";
    envfs.inputs.nixpkgs.follows = "nixpkgs";
    lanzaboote = {
      url = "github:nix-community/lanzaboote";

      # Optional but recommended to limit the size of your system closure.
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wallpkgs.url = "github:notashelf/wallpkgs";

    # non OS stuff
    papirus-folders-yavko = {
      url = "github:yavko/papirus-folders/add-makefile";
      flake = false;
    };
    wl-screenrec = {
      url = "github:russelltg/wl-screenrec";
      flake = false;
    };

    # neovim plugins
    vim-dirtytalk = {
      url = "github:psliwka/vim-dirtytalk";
      flake = false;
    };
    nvim-treesitter-endwise = {
      url = "github:RRethy/nvim-treesitter-endwise";
      flake = false;
    };
    nvim-cleanfold = {
      url = "github:lewis6991/cleanfold.nvim";
      flake = false;
    };
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux"];
      imports = [
        {config._module.args._inputs = inputs // {inherit (inputs) self;};}
        ./pkgs
      ];
      flake = {
        lib = import ./lib.nix inputs;
        nixosConfigurations = import ./hosts inputs;
      };
      perSystem = {
        config,
        inputs',
        pkgs,
        system,
        ...
      }: {
        #legacyPackages.${system} = inputs.nixpkgs.legacyPackages.${system};
        imports = [{_module.args.pkgs = inputs.nixpkgs.legacyPackages.${system} // (inputs.self.packages.${system});}];
        devShells.default = inputs'.devshell.legacyPackages.mkShell {
          packages = [
            pkgs.alejandra
            pkgs.git
          ];
          name = "dots";
        };
        formatter = pkgs.alejandra;
      };
    };
}
