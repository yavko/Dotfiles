{
  inputs,
  pkgs,
  ...
}: {
  programs.helix = {
    enable = true;
    package = inputs.helix.packages.${pkgs.system}.default;
    settings = {
      theme = "catppuccin_mocha";
      editor = {
        true-color = true;
        color-modes = true;
        cursorline = true;
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        # indent-guides = {
        #   render = true;
        #   rainbow = "dim";
        # };
        # rainbow-brackets = true;
      };
      keys.normal.space.u = {
        f = ":format"; # format using LSP formatter
        a = ["select_all" ":pipe alejandra -q"]; # format Nix with Alejandra
        w = ":set whitespace.render all";
        W = ":set whitespace.render none";
      };
    };
  };
}
