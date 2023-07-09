{
  pkgs,
  config,
  inputs,
  lib,
  ...
}: {
  nix = {
    package = inputs.nix-super.packages.${pkgs.system}.default; #pkgs.nixUnstable; # pkgs.nixFlake
    registry = let
      mapped = lib.mapAttrs (_: v: {flake = v;}) inputs;
    in
      mapped // {default = mapped.nixpkgs;};

    #nixPath = ["nixpkgs=/etc/nix/inputs/nixpkgs" "home-manager=/etc/nix/flake-channels/home-manager"];
    nixPath = lib.mapAttrsToList (key: _: "${key}=flake:${key}") config.nix.registry;
    #daemonCPUSchedPolicy = "idle";
    #daemonIOSchedClass = "idle";
    gc = {
      # set up garbage collection to run daily,
      # removing unused packages after three days
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 7d";
    };

    # Free up to 20GiB whenever there is less than 5GB left.
    extraOptions = ''
      min-free = ${toString (5 * 1024 * 1024 * 1024)}
      max-free = ${toString (20 * 1024 * 1024 * 1024)}
    '';
    settings = {
      auto-optimise-store = true;
      builders-use-substitutes = true;
      experimental-features = ["nix-command" "flakes" "recursive-nix" "ca-derivations"];
      flake-registry = "/etc/nix/registry.json";
      keep-derivations = true;
      keep-outputs = true;
      substituters = [
        "https://cache.ngi0.nixos.org"
        "https://cache.nixos.org"
        "https://nrdxp.cachix.org"
        "https://hyprland.cachix.org"
        "https://nix-community.cachix.org"
        "https://helix.cachix.org"
        "https://prismlauncher.cachix.org"
        "https://jakestanger.cachix.org" # ironbar
        "https://ezkea.cachix.org" # for aagl (if you know, you know)
        "https://cache.privatevoid.net"
        "https://nyx.chaotic.cx"
        "https://chaotic-nyx.cachix.org"
        "https://anyrun.cachix.org"
      ];
      trusted-public-keys = [
        "cache.ngi0.nixos.org-1:KqH5CBLNSyX184S9BKZJo1LxrxJ9ltnY2uAs5c/f1MA="
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nrdxp.cachix.org-1:Fc5PSqY2Jm1TrWfm88l6cvGWwz3s93c6IOifQWnhNW4="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
        "prismlauncher.cachix.org-1:GhJfjdP1RFKtFSH3gXTIQCvZwsb2cioisOf91y/bK0w="
        "jakestanger.cachix.org-1:VWJE7AWNe5/KOEvCQRxoE8UsI2Xs2nHULJ7TEjYm7mM=" # ironbar
        "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI=" # aagl (if you know, you know)
        "cache.privatevoid.net:SErQ8bvNWANeAvtsOESUwVYr2VJynfuc9JRwlzTTkVg="
        "nyx.chaotic.cx-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
        "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
        "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
      ];

      trusted-users = ["root" "@wheel" "nix-builder"];
      allowed-users = ["@wheel"];
      max-jobs = "auto";
      keep-going = true;
      log-lines = 20;
      warn-dirty = false;
      http-connections = 0;
      accept-flake-config = true;
    };
  };
}
