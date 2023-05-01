{...}: {
  programs.zellij = {
    enable = true;
    settings = {
      theme = "catppuccin-mocha";
      themes = {
        catppuccin-mocha = {
          bg = "#585b70"; # Surface2
          fg = "#cdd6f4";
          red = "#f38ba8";
          green = "#a6e3a1";
          blue = "#89b4fa";
          yellow = "#f9e2af";
          magenta = "#f5c2e7"; # Pink
          orange = "#fab387"; # Peach
          cyan = "#89dceb"; # Sky
          black = "#181825"; # Mantle
          white = "#cdd6f4";
        };
      };
    };
  };
}
