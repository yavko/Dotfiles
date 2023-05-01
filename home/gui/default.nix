{pkgs, ...} @ args: {
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
    #iwgtk
  ];
  imports = [
    ./eww
    ./dunst.nix
    ./ironbar.nix
    ./anyrun.nix
    ./hpr_scratcher.nix
    ./kvantum.nix
    ./rofi.nix
    ./wallpaper.nix
    ./xdg.nix
    ./productivity.nix
    ./wl-screenrec.nix
  ];

  programs = {
    firefox = {
      enable = true;
      #extensions = with pkgs.nur.repos.rycee.firefox-addons; {
      #	stylus
      #};
    };
    zathura.enable = true;
  };

  home.pointerCursor = {
    package = pkgs.catppuccin-cursors.mochaDark; #pkgs.bibata-cursors;
    name = "Catppuccin-Mocha-Dark-Cursors"; #"Bibata-Modern-Classic";
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  i18n.inputMethod.enabled = "fcitx5";
  i18n.inputMethod.fcitx5.addons = with pkgs; [fcitx5-mozc];

  gtk = import ./gtk.nix args;

  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = import ./hyprland.nix args;
    plugins.hy3.enable = true;
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
  };

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
}
