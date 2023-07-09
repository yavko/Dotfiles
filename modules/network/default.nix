{pkgs, ...} @ args: {
  hardware.bluetooth.enable = true;
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  services = {
    blueman.enable = true;
    nscd = {
      enableNsncd = true;
      enable = true;
    };
    printing = {
      enable = true;
      browsing = true;
      #listenAddresses = ["*:631"];
      allowFrom = ["all"];
      defaultShared = true;
      drivers = with pkgs; [epson-escpr2];
    };
    avahi = {
      enable = true;
      nssmdns = true;
      publish = {
        enable = true;
        userServices = true;
      };
    };
    avahi.openFirewall = true;
    opensnitch = import ./opensnitch.nix args;
  };
  # Open ports in the firewall.
  networking = {
    networkmanager.enable = true;

    hostName = "envious";
    nameservers = ["127.0.0.1" "::1"];
    # If using dhcpcd:
    dhcpcd.extraConfig = "nohook resolv.conf";
    # If using NetworkManager:
    networkmanager.dns = "none";
    firewall = {
      enable = true;
      allowedTCPPortRanges = [
        {
          from = 1714;
          to = 1764;
        } # KDE Connect
      ];
      allowedTCPPorts = [631 55300];
      allowedUDPPorts = [631];
      allowedUDPPortRanges = [
        {
          from = 1714;
          to = 1764;
        } # KDE Connect
      ];
    };
  };
  services.dnscrypt-proxy2 = {
    enable = true;
    settings = {
      ipv6_servers = true;
      require_dnssec = true;

      sources.public-resolvers = {
        urls = [
          "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
          "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
        ];
        cache_file = "/var/lib/dnscrypt-proxy2/public-resolvers.md";
        minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
      };

      # You can choose a specific set of servers from https://github.com/DNSCrypt/dnscrypt-resolvers/blob/master/v3/public-resolvers.md
      # server_names = [ ... ];
    };
  };

  systemd.services.dnscrypt-proxy2.serviceConfig = {
    StateDirectory = "dnscrypt-proxy";
  };
  #networking.wireless.iwd.enable = true;
  #networking.networkmanager.wifi.backend = "iwd";
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
}
