{pkgs, ...}: {
  imports = [
    # ./editors
    ./neovim-flake.nix
  ];

  home.packages = with pkgs; [
    rust-bin.nightly.latest.default
    cargo-generate
    neovide
    gh
  ];
  programs.ssh = {
    enable = true;
    # extraConfig = ''
    #   IdentityAgent ${config.home.homeDirectory}/.1password/agent.sock
    # '';
  };
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
      #key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEDGzxjYoalywVSGUXuU6cBDhuwgIIpElTjkz9fpBIxJ";
      signByDefault = true;
    };
    userEmail = "yavornkolev@gmail.com";
    userName = "yavko";
  };
}
