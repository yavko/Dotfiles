{pkgs, ...}: {
  # some stuff from raf's nyx :)
xdg.configFile."kdeglobals".source = "${(pkgs.catppuccin-kde.override {
    flavour = ["mocha"];
    accents = ["peach"];
    winDecStyles = ["modern"];
  })}/share/color-schemes/CatppuccinMochaPeach.colors";
  qt = {
    enable = true;
    # platformTheme = "gtk"; # just an override for QT_QPA_PLATFORMTHEME, takes "gtk" or "gnome"
    style = {
      package = pkgs.catppuccin-kde;
      name = "Catppuccin-Mocha-Dark";
    };
  };

  home.packages = with pkgs; [
		qt5.qttools
    qt6Packages.qtstyleplugin-kvantum
    libsForQt5.qtstyleplugin-kvantum
		qtstyleplugin-kvantum-qt4
	];
  home.sessionVariables = {
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    DISABLE_QT5_COMPAT = "0";
    QT_STYLE_OVERRIDE = "kvantum";
		CALIBRE_USE_DARK_PALETTE = "1";
  };
  xdg.configFile."Kvantum/catppuccin/catppuccin.kvconfig".source = builtins.fetchurl {
    url = "https://raw.githubusercontent.com/catppuccin/Kvantum/main/src/Catppuccin-Mocha-Peach/Catppuccin-Mocha-Peach.kvconfig";
    sha256 = "bf6e3ad5df044e7efd12c8bf707a67a69dd42c9effe36abc7eaa5eac12cd0a3c";
  };
  xdg.configFile."Kvantum/catppuccin/catppuccin.svg".source = builtins.fetchurl {
    url = "https://raw.githubusercontent.com/catppuccin/Kvantum/main/src/Catppuccin-Mocha-Peach/Catppuccin-Mocha-Peach.svg";
    sha256 = "fbd5c968afdd08812f55cfb5ad9eafb526a09d8c027e6c4378e16679e5ae44ae";
  };
  xdg.configFile."Kvantum/kvantum.kvconfig".text = "theme=catppuccin";
}
