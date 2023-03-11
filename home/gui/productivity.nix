{pkgs, ...}: {
  home.packages = with pkgs; [
    pitivi
    tenacity
    kdenlive
    inkscape-with-extensions
    #gimp-with-plugins
  ];
}
