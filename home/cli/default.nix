{pkgs, ...}: {
  imports = [
    ./bat.nix
    ./cava.nix
    ./macchina.nix
    ./zsh.nix
    ./btop.nix
    ./zellij.nix
  ];
  home.packages = with pkgs; [
    trashy
    socat
    unzip
    vivid
  ];
  programs.kitty = {
    enable = true;
    theme = "Catppuccin-Mocha";
    settings = {
      confirm_os_window_close = "0";
    };
  };
  programs.zoxide = {
    enable = true;
  };

  programs.fzf = {
    enable = true;
    defaultOptions = [
      "--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8"
      "--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc"
      "--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"
    ];
  };
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  programs.nix-index.enable = true;
  programs.command-not-found.enable = false;
}
