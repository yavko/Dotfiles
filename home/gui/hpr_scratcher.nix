{...}: {
  programs.hpr_scratcher = {
    enable = false;
    scratchpads = {
      term = {
        command = "kitty --class kitty-dropterm";
        animation = "fromTop";
        margin = 50;
        unfocus = "hide";
      };
      volume = {
        command = "pavucontrol";
        animation = "fromRight";
      };
    };
    binds = {
      volume = {
        mods = "SUPER";
        key = "P";
        type = "toggle";
      };
    };
  };

  wayland.windowManager.hyprland.extraConfig = ''
    windowrule = float,^(pavucontrol)$
    #windowrule = workspace special silent,^(pavucontrol)$
  '';
}
