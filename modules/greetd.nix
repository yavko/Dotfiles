{
  pkgs,
  inputs,
  default,
  lib,
  config,
  ...
}: let
  wallpkgs = inputs.wallpkgs.packages.${pkgs.system}.catppuccin;

  path = "${wallpkgs}/share/wallpapers/catppuccin/05.png";
  greetdSwayConfig = pkgs.writeText "greetd-sway-config" ''
    exec "dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP"
    input "type:touchpad" {
      tap enabled
    }
    seat seat0 xcursor_theme Bibata-Modern-Classic 24

    xwayland disable

    bindsym XF86MonBrightnessUp exec light -A 5
    bindsym XF86MonBrightnessDown exec light -U 5
    bindsym Print exec ${lib.getExe pkgs.grim} /tmp/regreet.png
    bindsym Mod4+shift+e exec swaynag \
      -t warning \
      -m 'What do you want to do?' \
      -b 'Poweroff' 'systemctl poweroff' \
      -b 'Reboot' 'systemctl reboot'

    exec "${lib.getExe config.programs.regreet.package} -l debug; swaymsg exit"
  '';
in {
  environment.systemPackages = with pkgs; [
    (catppuccin-gtk.override {
      size = "compact";
      accents = ["peach"];
      variant = "mocha";
    })
    #bibata-cursors
    catppuccin-cursors.mochaDark
    (papirus-icon-theme.override {color = "orange";})
    cage
    #greetd.gtkgreet
  ];

  programs.regreet = {
    enable = true;
    settings = {
      background = {
        inherit path;
        fit = "Cover";
      };
      GTK = {
        cursor_theme_name = "Catppuccin-Mocha-Dark-Cursors";
        font_name = "Roboto 12";
        icon_theme_name = "Papirus-Dark";
        theme_name = "Catppuccin-Mocha-Compact-Peach-Dark";
      };
    };
  };

  services.greetd.settings.default_session.command = "${config.programs.sway.package}/bin/sway --config ${greetdSwayConfig}";

  #environment.etc."greetd/environments".text = ''
  #  Hyprland
  #  zsh
  #'';
  security.pam.services.greetd.gnupg.enable = true;
}
