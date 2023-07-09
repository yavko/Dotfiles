{
  pkgs,
  inputs,
  lib,
  ...
} @ args: {
  home.packages = with pkgs; [
    pantheon.pantheon-agent-polkit
    qalculate-gtk
    #gnome.nautilus
    gnome.file-roller
    gnome.seahorse
    pcmanfm
    hyprpaper
    hyprpicker
    grimblast
    swappy
    libsForQt5.kleopatra
    brightnessctl
    wl-clipboard
    itd
    xorg.xcursorgen
    mullvad-vpn
    nicotine-plus
    opensnitch-ui
    #iwgtk
  ];
  imports = [
    #./eww
    ./dunst.nix
    ./ironbar
    ./anyrun.nix
    ./hpr_scratcher.nix
    ./kvantum.nix
    ./rofi.nix
    ./wallpaper.nix
    ./xdg.nix
    ./productivity.nix
    #./wl-screenrec.nix
    ./gtk.nix
  ];

  programs = {
    zathura.enable = true;
  };

  i18n.inputMethod.enabled = "fcitx5";
  i18n.inputMethod.fcitx5.addons = with pkgs; [fcitx5-mozc];

  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = import ./hyprland.nix args;
    plugins = [inputs.hy3.packages.${pkgs.system}.hy3];
    #package = pkgs.hyprland-hidpi;
    xwayland = {
      enable = true;
      hidpi = true;
    };
  };

  services = {
    nextcloud-client = {
      #enable = true;
      startInBackground = true;
    };
    kdeconnect.enable = true;
    kdeconnect.indicator = true;
    opensnitch-ui.enable = true;
  };

  xsession.preferStatusNotifierItems = true;
  systemd.user.services.patheon-polkit = {
    Unit = {
      Description = "Pantheon Polkit Agent";
      Requires = ["graphical-session.target"];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.pantheon.pantheon-agent-polkit}/libexec/policykit-1-pantheon/io.elementary.desktop.agent-polkit";
    };
    Install.WantedBy = ["hyprland-session.target"];
  };
  systemd.user.services.wl-clip-persist = {
    Unit.Description = "Persistent clipboard for Wayland";
    Service = {
      ExecStart = "${lib.getExe pkgs.wl-clip-persist} --clipboard both";
      Restart = "always";
    };
    Install.WantedBy = ["hyprland-session.target"];
  };
}
