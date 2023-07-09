# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  documentation = {
    enable = true;
    doc.enable = false;
    man.enable = true;
    dev.enable = false;
  };
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];
  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };
  systemd.oomd = {
    enableRootSlice = true;
    enableUserServices = true;
  };

  # Set your time zone.
  time.timeZone = "Europe/Sofia"; # "America/Los_Angeles";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.utf8";

  # Configure keymap in X11

  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      vaapiIntel # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      vaapiVdpau
      libvdpau-va-gl
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [vaapiIntel vaapiVdpau intel-media-driver libvdpau-va-gl];
    driSupport32Bit = true;
  };
  environment.variables = {
    VDPAU_DRIVER = lib.mkIf config.hardware.opengl.enable (lib.mkDefault "va_gl");
    LIBVA_DRIVER_NAME = "iHD";
  };
  boot.initrd.kernelModules = ["i915"];
  console.font = lib.mkDefault "${pkgs.terminus_font}/share/consolefonts/ter-v32n.psf.gz";
  console.earlySetup = lib.mkDefault true;

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  environment.pathsToLink = ["/share/zsh" "/share/bash-completion" "/share/nix-direnv"];

  age.identityPaths = ["/home/yavor/.ssh/id_ed25519"];
  age.secrets.pass.file = ../../secrets/pass.age;
  age.secrets.downonspot = {
    file = ../../secrets/downonspot.age;
    path = "/home/yavor/music-downloads/settings.json";
    mode = "774";
  };
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.yavor = {
    isNormalUser = true;
    description = "Yavor Kolev";
    extraGroups = ["networkmanager" "wheel" "video" "input" "audio" "scanner" "lp"];
    passwordFile = config.age.secrets.pass.path;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = let
    steam = pkgs.steam.override {
      extraPkgs = pkgs:
        with pkgs; [
          keyutils
          libkrb5
          libpng
          libpulseaudio
          libvorbis
          stdenv.cc.cc.lib
          xorg.libXcursor
          xorg.libXi
          xorg.libXinerama
          xorg.libXScrnSaver
        ];
      extraProfile = "export GDK_SCALE=2";
    };
  in
    with pkgs; [
      git
      glib
      slurp
      steam
      via
      vial
      sbctl
    ];
  environment.etc = with inputs; {
    "nix/flake-channels/system".source = self;
    "nix/flake-channels/nixpkgs".source = nixpkgs;
    "nix/flake-channels/home-manager".source = hm;
  };

  programs._1password.enable = true;
  programs._1password-gui.enable = true;
  programs._1password-gui.polkitPolicyOwners = ["yavor"];
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };
  programs.anime-game-launcher.enable = true;
  programs.honkers-railway-launcher.enable = true;
  programs.honkers-launcher.enable = true;
  programs.anime-borb-launcher.enable = true;
  programs.gamemode.enable = true;

  # use Wayland where possible
  environment.variables.NIXOS_OZONE_WL = "1";

  location.provider = "geoclue2";

  programs.hyprland.enable = true;
  programs.hyprland.xwayland.hidpi = true;

  programs.sway = {
    enable = true;
    #package = inputs.self.packages.${pkgs.hostPlatform.system}.sway-hidpi;
  };

  programs.dconf.enable = true;
  programs.light.enable = true;
  hardware = {
    sane.enable = true;
    sane.extraBackends = with pkgs; [epkowa];
  };
  services = {
    # needed for gnome3 pinentry
    dbus.packages = with pkgs; [dconf gcr udisks2];
    gnome.gnome-keyring.enable = true;
    # provide location
    geoclue2 = {
      enable = true;
      appConfig.gammastep = {
        isAllowed = true;
        isSystem = false;
      };
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      jack.enable = true;
      pulse.enable = true;
    };
    flatpak.enable = true;
    ratbagd.enable = true;
    hardware.openrgb = {
      #enable = true;
      package = pkgs.openrgb-with-all-plugins;
      #motherboard = "intel";
    };
    tlp = {
      enable = true;
      settings = {
        PCIE_ASPM_ON_BAT = "powersupersave";
        DEVICES_TO_DISABLE_ON_STARTUP = "bluetooth";
        NMI_WATCHDOG = 0;
      };
    };
    thermald.enable = true;

    upower.enable = true;
    gvfs.enable = true;
    udev = {
      packages = with pkgs; [gnome.gnome-settings-daemon vial via qmk-udev-rules numworks-udev-rules picoprobe-udev-rules];
    };
  };
  # This includes support for suspend-to-RAM and powersave features on laptops
  powerManagement.enable = true;
  # Enable powertop auto tuning on startup.
  powerManagement.powertop.enable = false;
  xdg.portal.enable = true;

  system.stateVersion = "22.11";
}
