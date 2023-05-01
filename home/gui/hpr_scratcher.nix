{...}: {
  programs.hpr_scratcher = {
    enable = true;
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
  };
}
