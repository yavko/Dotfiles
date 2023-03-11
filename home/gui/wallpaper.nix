{
  config,
  pkgs,
  ...
}: {
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
  xdg.configFile."hypr/hyprpaper.conf" = {
    text = let
      path = builtins.fetchurl {
        url = "https://raw.githubusercontent.com/catppuccin/wallpapers/main/misc/cat-sound.png";
        sha256 = "5c2dc947e37e6c98938dc2fd9dabdfc074a0594467e7668f4c3d846fedf9fdfa";
      };
    in ''
      preload=${path}
      wallpaper=eDP-1,${path}
      ipc=off
    '';
  };
}
