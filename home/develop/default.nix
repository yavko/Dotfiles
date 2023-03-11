{pkgs, ...}: {
  imports = [
    ./editors
  ];
  home.packages = with pkgs; [
    rust-bin.nightly.latest.default
    cargo-generate
    neovide
    gh
  ];
  programs.git = {
    enable = true;
    difftastic = {
      enable = true;
    };
    extraConfig = {
      diff.colorMoved = "default";
      merge.conflictstyle = "diff3";
      url = {
        "https://github.com/" = {insteadOf = "gh:";};
        "git@github.com:" = {insteadOf = "gh:";};
      };
      #gpg.ssh.program = "${pkgs._1password-gui}/share/1password/op-ssh-sign";
      #gpg.format = "ssh";
    };
    aliases = {};
    ignores = ["*~" "*.swp" "*result*" ".direnv" "node_modules"];
    signing = {
      key = "F07D19A32407F857";
      signByDefault = true;
    };
    userEmail = "yavornkolev@gmail.com";
    userName = "yavko";
  };
}
