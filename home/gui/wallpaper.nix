{
  pkgs,
  inputs,
  ...
}: let
  wallpkgs = inputs.wallpkgs.packages.${pkgs.system}.catppuccin;
in {
  systemd.user.services.hyprpaper = {
    Unit = {
      Description = "Hyprland wallpaper daemon";
      Requires = ["graphical-session.target"];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.hyprpaper}/bin/hyprpaper";
      Restart = "on-failure";
    };
    Install.WantedBy = ["hyprland-session.target"];
  };
  home.packages = [wallpkgs];
  xdg.configFile."hypr/hyprpaper.conf" = {
    text = let
      path = "${wallpkgs}/share/wallpapers/catppuccin/05.png";
    in ''
      preload=${path}
      wallpaper=eDP-1,${path}
      splash=true
      ipc=off
    '';
  };
}
