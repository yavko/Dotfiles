{pkgs, ...}: {
  home.packages = with pkgs; [libsForQt5.qtstyleplugin-kvantum];
  home.sessionVariables.QT_STYLE_OVERRIDE = "kvantum";
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
