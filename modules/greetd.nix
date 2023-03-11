{
  pkgs,
  inputs,
  default,
  ...
}: {
  environment.systemPackages = with pkgs; [
    (catppuccin-gtk.override {size = "compact";})
    #bibata-cursors
		catppuccin-cursors.mochaDark
    (papirus-icon-theme.override {color = "orange";})
    cage
    greetd.gtkgreet
  ];

  environment.etc."gtk-3.0/settings.ini".text = ''
    [Settings]
    gtk-cursor-theme-name=Catppuccin-Mocha-Dark-Cursors
    gtk-cursor-theme-size=24
    gtk-font-name=Roboto
    gtk-icon-theme-name=Papirus-Dark
    gtk-theme-name=Catppuccin-Orange-Dark-Compact
  '';

#gtk-cursor-theme-name=Bibata-Modern-Classic

  services.greetd = {
    enable = true;
    settings = {
      default_session.command = let
        path = builtins.fetchurl {
          url = "https://raw.githubusercontent.com/catppuccin/wallpapers/main/misc/cat-sound.png";
          sha256 = "5c2dc947e37e6c98938dc2fd9dabdfc074a0594467e7668f4c3d846fedf9fdfa";
        };
        gtk-theme-path = "${pkgs.catppuccin-gtk.override {size = "compact";}}/share/themes/Catppuccin-Orange-Dark-Compact/gtk-3.0/gtk-dark.css";
        gtkgreetStyle = pkgs.writeText "greetd-gtkgreet.css" ''
          @import url("${gtk-theme-path}");
               window {
                 background-image: url("${path}");
                 background-position: center;
                 background-repeat: no-repeat;
                 background-size: cover;
                 background-color: black;
               }
               #body > box > box > label {
                 text-shadow: 0 0 3px #1e1e2e;
                 color: #f5e0dc;
               }
               entry {
                 color: #f5e0dc;
                 background: rgba(30, 30, 46, 1); /* 0.8 */
                 border-radius: 16px;
                 box-shadow: 0 0 5px #1e1e2e;
               }
               #clock {
                 color: #f5e0dc;
                 text-shadow: 0 0 3px #1e1e2e;
               }
               .text-button { border-radius: 16px; }
        '';
        #greetdSwayConfig = pkgs.writeText "greetd-sway-config" ''
        #  exec "${pkgs.greetd.gtkgreet}/bin/gtkgreet -l -s ${gtkgreetStyle}; swaymsg exit"
        #  bindsym Mod4+shift+e exec swaynag \
        #    -t warning \
        #    -m 'What do you want to do?' \
        #    -b 'Poweroff' 'systemctl poweroff' \
        #    -b 'Reboot' 'systemctl reboot'
        #  seat seat0 xcursor_theme Bibata-Modern-Classic 24
        #  exec dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP
        #'';
        #in "${inputs.self.packages.${pkgs.system}.sway-hidpi}/bin/sway --config ${greetdSwayConfig}";
      in "${pkgs.dbus}/bin/dbus-run-session ${pkgs.cage}/bin/cage -s -- ${pkgs.greetd.gtkgreet}/bin/gtkgreet -s ${gtkgreetStyle}";
    };
  };

  environment.etc."greetd/environments".text = ''
    Hyprland
    zsh
  '';
}
