{
  description = "Yavko's Dotfiles";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    hm = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix.url = "github:yaxitech/ragenix";
    hyprland.url = "github:hyprwm/Hyprland/"; #2cbb10d850f0860fcb1c940ebc047c7c4deb9e91";
    helix.url = "github:helix-editor/helix";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    /*
      neovim-flake = {
      url = "github:notashelf/neovim-flake/fixHomeManager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    */
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
    aagl.url = "/home/yavor/Projects/External/aagl-gtk-on-nix/";
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
    devshell.url = "github:numtide/devshell";
    ironbar = {
      url = "github:JakeStanger/ironbar";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rust-overlay.follows = "rust-overlay";
    };
    anyrun = {
      url = "github:Kirottu/anyrun";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hpr_scratcher = {
      #url = "github:yavko/hpr_scratcher";
      url = "/home/yavor/Projects/External/hpr-scratcher";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hy3 = {
      url = "github:outfoxxed/hy3";
      inputs.hyprland.follows = "hyprland";
    };
    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
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
        imports = [{_module.args.pkgs = inputs.nixpkgs.legacyPackages.${system};}];
        devShells.default = inputs'.devshell.legacyPackages.mkShell {
          packages = [
            pkgs.alejandra
            pkgs.git
            config.packages.repl
          ];
          name = "dots";
        };
        formatter = pkgs.alejandra;
      };
    };
  nixConfig = {
    extra-substituters = [
      "https://nrdxp.cachix.org"
      "https://hyprland.cachix.org"
      "https://nix-community.cachix.org"
      "https://helix.cachix.org"
      "https://prismlauncher.cachix.org"
      "https://jakestanger.cachix.org" # ironbar
      "https://ezkea.cachix.org" # for aagl (if you know, you know)
    ];
    extra-trusted-public-keys = [
      "nrdxp.cachix.org-1:Fc5PSqY2Jm1TrWfm88l6cvGWwz3s93c6IOifQWnhNW4="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
      "prismlauncher.cachix.org-1:GhJfjdP1RFKtFSH3gXTIQCvZwsb2cioisOf91y/bK0w="
      "jakestanger.cachix.org-1:VWJE7AWNe5/KOEvCQRxoE8UsI2Xs2nHULJ7TEjYm7mM=" # ironbar
      "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI=" # aagl (if you know, you know)
    ];
  };
}
