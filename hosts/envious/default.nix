# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  inputs,
  ...
}: {
  nix = {
    #package = pkgs.nixFlakes;
    settings = {
      auto-optimise-store = true;
      experimental-features = ["nix-command" "flakes"];
      substituters = [
        "https://nrdxp.cachix.org"
        "https://hyprland.cachix.org"
        "https://nix-community.cachix.org"
        "https://helix.cachix.org"
        "https://prismlauncher.cachix.org"
        "https://jakestanger.cachix.org" # ironbar
      ];
      trusted-public-keys = [
        "nrdxp.cachix.org-1:Fc5PSqY2Jm1TrWfm88l6cvGWwz3s93c6IOifQWnhNW4="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
        "prismlauncher.cachix.org-1:GhJfjdP1RFKtFSH3gXTIQCvZwsb2cioisOf91y/bK0w="
        "jakestanger.cachix.org-1:VWJE7AWNe5/KOEvCQRxoE8UsI2Xs2nHULJ7TEjYm7mM=" # ironbar
      ];
      trusted-users = ["root" "@wheel"];
    };
  };
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    #./fonts.nix
    #./greetd.nix
  ];

  hardware.bluetooth.enable = true;

  # Bootloader.
  boot.plymouth.enable = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
	boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;

  networking.hostName = "envious"; # Define your hostname.
  #envious
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.utf8";

  # Configure keymap in X11

  hardware.opengl.enable = true;
	hardware.opengl.driSupport32Bit = true;
  
	programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  environment.pathsToLink = ["/share/zsh"];

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
    extraGroups = ["networkmanager" "wheel" "video" "input" "audio"];
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
      #git
      #kitty
      glib
      slurp
      steam
      #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
      #  wget
    ];

  programs._1password-gui.enable = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };
	programs.gamemode.enable = true;

  security = {
    # allow wayland lockers to unlock the screen
    pam.services = {
      #swaylock.text = "auth include login";
      kwallet.enableKwallet = true;
      gnome-keyring.enableGnomeKeyring = true;
			greetd.enableGnomeKeyring = true;
    };
    rtkit.enable = true;
    sudo.wheelNeedsPassword = false;
  };

  # use Wayland where possible
  environment.variables.NIXOS_OZONE_WL = "1";

  location.provider = "geoclue2";

  programs.hyprland.enable = true;

  programs.dconf.enable = true;
  programs.light.enable = true;
  services = {
    blueman.enable = true;
    # needed for gnome3 pinentry
    dbus.packages = [pkgs.gcr];
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
    printing.enable = true;
    flatpak.enable = true;
    ratbagd.enable = true;
    tlp = {
      enable = true;
      settings = {
        PCIE_ASPM_ON_BAT = "powersupersave";
        DEVICES_TO_DISABLE_ON_STARTUP = "bluetooth";
        NMI_WATCHDOG = 0;
      };
    };

    upower.enable = true;
    gvfs.enable = true;
    # needed for GNOME services outside of GNOME Desktop
    udev = {
			# add support for CMSIS-DAP debug probes without root
			# and add support for using numworks website
			extraRules = ''
ACTION!="add|change", GOTO="probe_rs_rules_end"

SUBSYSTEM=="gpio", MODE="0660", GROUP="plugdev", TAG+="uaccess"

SUBSYSTEM!="usb|tty|hidraw", GOTO="probe_rs_rules_end"

ATTRS{product}=="*CMSIS-DAP*", MODE="660", GROUP="plugdev", TAG+="uaccess"

LABEL="probe_rs_rules_end"


SUBSYSTEM=="usb", ATTR{idVendor}=="0483", ATTR{idProduct}=="a291", TAG+="uaccess"
SUBSYSTEM=="usb", ATTR{idVendor}=="0483", ATTR{idProduct}=="df11", TAG+="uaccess"
			'';
			packages = with pkgs; [gnome.gnome-settings-daemon];
		};
  };

  xdg.portal.enable = true;

  #nixpkgs.config.packageOverrides = pkgs: {
  #  nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
  #    inherit pkgs;
  #  };
  #};

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall = {
    enable = true;
    allowedTCPPortRanges = [
      {
        from = 1714;
        to = 1764;
      } # KDE Connect
    ];
    allowedUDPPortRanges = [
      {
        from = 1714;
        to = 1764;
      } # KDE Connect
    ];
  };
	#networking.wireless.iwd.enable = true;
	#networking.networkmanager.wifi.backend = "iwd";
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?
}
