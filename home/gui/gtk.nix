{
  pkgs,
  config,
  ...
}: rec {
  home.packages = [
    home.pointerCursor.package
    gtk.theme.package
    gtk.iconTheme.package
  ];
  gtk = {
    enable = true;

    font = {
      name = "Roboto";
      package = pkgs.roboto;
    };

    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.catppuccin-papirus-folders.override {
        flavor = "mocha";
        accent = "peach";
      };
    };

    theme = {
      name = "Catppuccin-Mocha-Compact-Peach-dark";
      package = pkgs.catppuccin-gtk.override {
        size = "compact";
        accents = ["peach"];
        variant = "mocha";
      };
    };
  };
  home.pointerCursor = {
    package = pkgs.catppuccin-cursors.mochaDark;
    name = "Catppuccin-Mocha-Dark-Cursors";
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };
}
