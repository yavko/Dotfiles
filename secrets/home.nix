{
  config,
  pkgs,
  ...
}: {
  #imports = [./home-secrets.nix];
  home.packages = with pkgs; [pinentry];
  programs.gpg = {
    enable = true;
    homedir = "${config.xdg.dataHome}/gnupg";
  };
  services.gpg-agent = {
    enable = true;
    pinentryFlavor = "gnome3";
  };
}
