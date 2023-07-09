{
  pkgs,
  lib,
  config,
  ...
}: {
  enable = true;
  settings = {
    ProcMonitorMethod = "proc";
  };
  rules = builtins.mapAttrs (name: value: let
    base = {
      inherit name;
      enabled =
        if builtins.hasAttr "enabled" value
        then value.enabled
        else true;
      action =
        if builtins.hasAttr "action" value
        then value.action
        else "allow";
      duration = "always";
    };

    mkList = list: {
      type = "list";
      operand = "list";
      sensitive = false;
      data = builtins.toJSON list;
      inherit list;
    };

    operator =
      if value ? list
      then mkList value.list
      else if value ? path
      then {
        type = value.pathType or "simple";
        operand = "process.path";
        sensitive = false;
        data = value.path;
      }
      else if value ? def
      then
        mkList ([
            {
              type = (value.def).pathType or "simple";
              operand = "process.path";
              sensitive = false;
              data = value.def.path;
            }
          ]
          ++ lib.optional (value.def ? command) {
            type = (value.def).commandType or "simple";
            operand = "process.command";
            sensitive = false;
            data = value.def.command;
          }
          ++ lib.optional (value.def ? host) (value.def.host name)
          ++ lib.optional (value.def ? ports) value.def.ports
          ++ lib.optional (value.def ? ips) (value.def.ips name)
          ++ lib.optional (value.def ? allowLocal && value.def.allowLocal) {
            type = "regexp";
            operand = "dest.ip";
            sensitive = false;
            data = "^(127.0.0.1|::1)$";
          })
      else value.operator;
  in
    base // {inherit operator;}) (let
    mkListData = {
      single,
      list,
    }: data: rulename:
      if single.operand == "dest.ip" && builtins.isList data
      then {
        inherit (list) type operand;
        sensitive = false;
        data = pkgs.writeTextFile {
          name = "opensnitch-rule-${rulename}";
          destination = "/rule.txt";
          text = builtins.concatStringsSep "\n" data;
        };
      }
      else if builtins.isList data
      then {
        inherit (list) type operand;
        sensitive = false;
        data = pkgs.writeTextFile {
          name = "opensnitch-rule-${rulename}";
          destination = "/rule.txt";
          text = builtins.concatStringsSep "\n" (map list.map data);
        };
      }
      else {
        inherit (single) type operand;
        sensitive = false;
        data = data;
      };

    mkPort = port: {
      type = "simple";
      operand = "dest.port";
      sensitive = false;
      data = port;
    };

    mkPortRegex = regex: {
      type = "regexp";
      operand = "dest.port";
      sensitive = false;
      data = regex;
    };

    mkHost = host: rulename:
      mkListData {
        single = {
          type = "simple";
          operand = "dest.host";
        };
        list = {
          type = "lists";
          operand = "lists.domains";
          map = host: "127.0.0.1 ${host}";
        };
      }
      host
      rulename;

    mkIPs = ips: rulename:
      mkListData {
        single = {
          type = "simple";
          operand = "dest.ip";
        };
        list = {
          type = "lists";
          operand = "lists.ips";
        };
      }
      ips
      rulename;
    mkIP = ip: {
      type = "simple";
      operand = "dest.ip";
      sensitive = false;
      data = ip;
    };

    mkRegex = host: rulename:
      mkListData {
        single = {
          type = "regexp";
          operand = "dest.host";
        };
        list = {
          type = "lists";
          operand = "lists.domains_regexp";
          map = host: host;
        };
      }
      host
      rulename;
  in {
    nix-allow = {
      path = "${config.nix.package}/bin/nix";
    };
    nix-stable-allow = {
      path = "${pkgs.nix}/bin/nix";
    };
    systemd-timesyncd.def = {
      path = "${pkgs.systemd}/lib/systemd/systemd-timesyncd";
      #host = mkRegex "^(|.*\\.)ntp\\.org$";
      host = mkRegex (map (x: let x2 = builtins.replaceStrings ["."] ["\\."] x; in "^${x2}$") config.networking.timeServers);
    };
    mullvad-daemon.def = {
      path = "${config.services.mullvad-vpn.package}/bin/.mullvad-daemon-wrapped";
      ports = mkPortRegex "^(443|80|1401|53|1194|1195|1196|1197|1300|1301|1302|1303|1400)$";
      ips = mkIPs ["45.83.223.196" "62.133.44.202"];
      host = mkRegex "^(|.*\\.)mullvad\\.net$";
    };
    allow-mullvad-gui = {
      path = "${pkgs.mullvad-vpn}/share/mullvad/mulvad-gui";
    };
    avahi-daemon.def = {
      path = "${pkgs.avahi}/bin/avahi-daemon";
      ports = mkPort "5353";
      ips = mkIPs [
        "ff02::fb"
        "224.0.0.251"
      ];
    };
    cups-browsed.def = {
      path = "${pkgs.cups-filters}/bin/cups-browsed";
      ports = mkPortRegex "^(53|631|5353|137|139|445|161|443|515|9100|9101|9102)$";
    };
    nscd.def = {
      path = "${pkgs.nsncd}/bin/nsncd";
      ports = mkPort "53";
    };
    kdeconnect.def = {
      path = "${pkgs.libsForQt5.kdeconnect-kde}/libexec/.kdeconnectd-wrapped";
      ports = mkPortRegex "^(17[2-5][0-9]|171[4-9]|176[0-4])$";
    };
    "1password".def = {
      path = "${config.programs._1password-gui.package}/share/1password/1password";
      pathType = "regexp";
      ports = mkPort "443";
      host = mkRegex [
        "^(|.*\\.)1password\\.com$"
        "^cache\\.agilebits\\.com$"
        "^(|.*\\.)1passwordservices\\.com$"
        "^(|.*\\.)1passwordusercontent\\.com$"
        "^(|.*\\.)api.pwnedpasswords\\.com$"
        "^api\\.privacy\\.com$"
      ];
    };
    ncmpcpp.def = {
      path = "${pkgs.ncmpcpp.override {visualizerSupport = true;}}/bin/ncmpcpp";
      allowLocal = true;
    };
    allow-dnscrypt-proxy = {
      path = "${pkgs.dnscrypt-proxy2}/bin/dnscrypt-proxy";
      #ports = mkPortRegex "^(443|8443|80)$";
    };
    allow-networkmanager = {
      path = "${pkgs.networkmanager}/bin/NetworkManager";
    };
    firefox-common.def = {
      path = "${pkgs.firefox}/lib/firefox/firefox";
      ports = mkPortRegex "^(53|80|443|50007)$";
    };

    osu-allow-domains.def = {
      path = "^${pkgs.osu-lazer-bin}/.*";
      pathType = "regexp";
      host = mkRegex [
        "^(|.*\\.)ppy\\.sh$"
        "^api\\.github\\.com$"
      ];
    };

    "reject-gvt1.com" = {
      action = "reject";
      operator = {
        type = "regexp";
        operand = "dest.host";
        sensitive = false;
        data = "^(|.*\\.)gvt1.com$";
      };
    };

    allow-mpd-locally.def = {
      path = "${pkgs.mpd}/bin/mpd";
      allowLocal = true;
    };
  });
}
