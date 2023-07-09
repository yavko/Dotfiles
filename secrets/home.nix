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
    enableSshSupport = true;
    sshKeys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEDGzxjYoalywVSGUXuU6cBDhuwgIIpElTjkz9fpBIxJ"];
  };
}
