{nix-colors, ...}: {
  colorScheme = nix-colors.colorSchemes.catppuccin;
  home.username = "yavor";
  home.homeDirectory = "/home/yavor";
  home.stateVersion = "22.11";

  programs.home-manager.enable = true;
}