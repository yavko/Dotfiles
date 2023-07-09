{
  pkgs,
  inputs,
  lib,
  ...
}: {
  # Bootloader.
  boot.plymouth = {
    enable = true;
    themePackages = [(pkgs.catppuccin-plymouth.override {variant = "mocha";})];
    theme = "catppuccin-mocha";
    #font = "${pkgs.nerdfonts.override {fonts = ["VictorMono"];}}/share/fonts/truetype/NerdFonts/Victor\ Mono\ Regular\ Nerd\ Font\ Complete\ Mono.ttf";
  };
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest; # inputs.chaotic.packages.${pkgs.hostPlatform.system}.linuxPackages_cachyos; #pkgs.linuxPackages_cachyos;
  boot.bootspec.enable = true;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };
}
