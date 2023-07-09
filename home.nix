{nix-colors, ...}: {
  colorScheme = nix-colors.colorSchemes.catppuccin-mocha;
  home.username = "yavor";
  home.homeDirectory = "/home/yavor";
  home.stateVersion = "22.11";
  manual = {
    html.enable = false;
    json.enable = false;
    manpages.enable = false;
  };
  programs.home-manager.enable = true;
}
