{pkgs, ...}: {
  imports = [
    ./mpv.nix
    ./music.nix
  ];
  home.packages = with pkgs; [
    playerctl
    pavucontrol
    imv
  ];
}
