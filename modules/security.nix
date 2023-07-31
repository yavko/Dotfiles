{
  pkgs,
  lib,
  ...
}: {
  # paths not working yay
  #services.clamav.daemon.enable = true;
  #services.clamav.updater.enable = true;

  environment.memoryAllocator.provider = "graphene-hardened";
  services = {
    mullvad-vpn.enable = true;
    usbguard = {
      enable = true;
      rules = ''
allow id 1d6b:0002 serial "0000:00:14.0" name "xHCI Host Controller" hash "jEP/6WzviqdJ5VSeTUY8PatCNBKeaREvo2OqdplND/o=" parent-hash "rV9bfLq7c2eA4tYjVjwO4bxhm+y6GgZpl9J60L0fBkY=" with-interface 09:00:00 with-connect-type ""
allow id 1d6b:0003 serial "0000:00:14.0" name "xHCI Host Controller" hash "3Wo3XWDgen1hD5xM3PSNl3P98kLp1RUTgGQ5HSxtf8k=" parent-hash "rV9bfLq7c2eA4tYjVjwO4bxhm+y6GgZpl9J60L0fBkY=" with-interface 09:00:00 with-connect-type ""
allow id 1235:8211 serial "Y72EB6E1AD7499" name "Scarlett Solo USB" hash "vYKb5BFrLgfYzbTqAtyq0N2yZisUuqjchfbd1NjGgiE=" parent-hash "jEP/6WzviqdJ5VSeTUY8PatCNBKeaREvo2OqdplND/o=" with-interface { 01:01:20 01:02:20 01:02:20 01:02:20 01:02:20 ff:01:20 } with-connect-type "hotplug"
allow id 258a:0033 serial "" name "Wired Gaming Mouse" hash "NjvNTGeMdzH8KOqM6YIuBwfVCZluftC/mdg5mR2aLlY=" parent-hash "jEP/6WzviqdJ5VSeTUY8PatCNBKeaREvo2OqdplND/o=" via-port "1-2" with-interface { 03:01:02 03:01:01 } with-connect-type "hotplug"
allow id 046d:c539 serial "" name "USB Receiver" hash "zPVf0/h8u0iaLZgla3hm9BjINDTSEEIMF/GWCyOYCwo=" parent-hash "jEP/6WzviqdJ5VSeTUY8PatCNBKeaREvo2OqdplND/o=" via-port "1-3" with-interface { 03:01:01 03:01:02 03:00:00 } with-connect-type "hotplug"
allow id 1050:0407 serial "" name "YubiKey OTP+FIDO+CCID" hash "Q+A8QQReKclmBSaDIYja0w4Bx6ld2IU6wF7HFKdtJ3Q=" parent-hash "jEP/6WzviqdJ5VSeTUY8PatCNBKeaREvo2OqdplND/o=" via-port "1-5" with-interface { 03:01:01 03:00:00 0b:00:00 } with-connect-type "hotplug"
allow id 04f2:b50c serial "" name "HP Truevision HD" hash "xR2ZRjJzpB6sW1I9lU5CPcYRjCiW23iyfnr67QjSNWw=" parent-hash "jEP/6WzviqdJ5VSeTUY8PatCNBKeaREvo2OqdplND/o=" via-port "1-6" with-interface { 0e:01:00 0e:02:00 0e:02:00 0e:02:00 0e:02:00 0e:02:00 0e:02:00 0e:02:00 0e:02:00 0e:02:00 0e:02:00 0e:02:00 0e:02:00 } with-connect-type "hardwired"
allow id 8087:0a2a serial "" name "" hash "7jCRH2DCYUfdP9zZCYIQH6Z5QWx8Nzt8sX21UHwxIqA=" parent-hash "jEP/6WzviqdJ5VSeTUY8PatCNBKeaREvo2OqdplND/o=" via-port "1-7" with-interface { e0:01:01 e0:01:01 e0:01:01 e0:01:01 e0:01:01 e0:01:01 e0:01:01 } with-connect-type "hardwired"
allow id 04f3:22f6 serial "" name "Touchscreen" hash "x1+RDZDWJlnHus7DN6iDdnCOJj52ogmObdk0JlocWtc=" parent-hash "jEP/6WzviqdJ5VSeTUY8PatCNBKeaREvo2OqdplND/o=" via-port "1-8" with-interface 03:00:00 with-connect-type "hardwired"
      '';
      #dbus.enable = true;
      IPCAllowedGroups = ["wheel"];
      IPCAllowedUsers = [];
    };
  };

  security = {
    rtkit.enable = true;
    polkit.enable = true;
    pam.services = {
      greetd.enableGnomeKeyring = true;
      greetd.enableKwallet = true;
    };
    protectKernelImage = true;
    lockKernelModules = false; # breaks virtd, wireguard and iptables

    # force-enable the Page Table Isolation (PTI) Linux kernel feature
    forcePageTableIsolation = true;

    # User namespaces are required for sandboxing. Better than nothing imo.
    allowUserNamespaces = true;

    apparmor = {
      enable = true;
      killUnconfinedConfinables = true;
      packages = [pkgs.apparmor-profiles];
    };

    virtualisation = {
      #  flush the L1 data cache before entering guests
      flushL1DataCache = "always";
    };

    auditd.enable = true;
    audit = {
      enable = true;
      rules = [
        "-a exit,always -F arch=b64 -S execve"
      ];
    };
    sudo = {
      enable = lib.mkDefault true;
      execWheelOnly = true;
      wheelNeedsPassword = true;
      extraConfig = ''
        # rollback results in sudo lectures after each reboot
        Defaults lecture = never
      '';
    };
  };

  # security tweaks borrowed from @hlissner & @fufexan & @NotAShelf
  boot.kernel.sysctl = {
    # The Magic SysRq key is a key combo that allows users connected to the
    # system console of a Linux kernel to perform some low-level commands.
    # Disable it, since we don't need it, and is a potential security concern.
    "kernel.sysrq" = 0;

    ## TCP hardening
    # Prevent bogus ICMP errors from filling up logs.
    "net.ipv4.icmp_ignore_bogus_error_responses" = 1;
    # Reverse path filtering causes the kernel to do source validation of
    # packets received from all interfaces. This can mitigate IP spoofing.
    "net.ipv4.conf.default.rp_filter" = 1;
    "net.ipv4.conf.all.rp_filter" = 1;
    # Do not accept IP source route packets (we're not a router)
    "net.ipv4.conf.all.accept_source_route" = 0;
    "net.ipv6.conf.all.accept_source_route" = 0;
    # Don't send ICMP redirects (again, we're on a router)
    "net.ipv4.conf.all.send_redirects" = 0;
    "net.ipv4.conf.default.send_redirects" = 0;
    # Refuse ICMP redirects (MITM mitigations)
    "net.ipv4.conf.all.accept_redirects" = 0;
    "net.ipv4.conf.default.accept_redirects" = 0;
    "net.ipv4.conf.all.secure_redirects" = 0;
    "net.ipv4.conf.default.secure_redirects" = 0;
    "net.ipv6.conf.all.accept_redirects" = 0;
    "net.ipv6.conf.default.accept_redirects" = 0;
    # Protects against SYN flood attacks
    "net.ipv4.tcp_syncookies" = 1;
    # Incomplete protection again TIME-WAIT assassination
    "net.ipv4.tcp_rfc1337" = 1;

    ## TCP optimization
    # TCP Fast Open is a TCP extension that reduces network latency by packing
    # data in the sender’s initial TCP SYN. Setting 3 = enable TCP Fast Open for
    # both incoming and outgoing connections:
    "net.ipv4.tcp_fastopen" = 3;
    # Bufferbloat mitigations + slight improvement in throughput & latency
    "net.ipv4.tcp_congestion_control" = "bbr";
    "net.core.default_qdisc" = "cake";

    "kernel.kexec_load_disabled" = 1;

    # Restrict ptrace() usage to processes with a pre-defined relationship
    # (e.g., parent/child)
    "kernel.yama.ptrace_scope" = 2;
    # Hide kptrs even for processes with CAP_SYSLOG
    "kernel.kptr_restrict" = 2;
    # Disable bpf() JIT (to eliminate spray attacks)
    "net.core.bpf_jit_enable" = false;
    # Disable ftrace debugging
    "kernel.ftrace_enabled" = false;
  };
  boot.kernelModules = ["tcp_bbr"];

  boot.blacklistedKernelModules = [
    # Obscure network protocols
    "ax25"
    "netrom"
    "rose"
    # Old or rare or insufficiently audited filesystems
    "adfs"
    "affs"
    "bfs"
    "befs"
    "cramfs"
    "efs"
    "erofs"
    "exofs"
    "freevxfs"
    "f2fs"
    "vivid"
    "gfs2"
    "ksmbd"
    "nfsv4"
    "nfsv3"
    "cifs"
    "nfs"
    "cramfs"
    "freevxfs"
    "jffs2"
    "hfs"
    "hfsplus"
    "squashfs"
    "udf"
    "btusb"
    "hpfs"
    "jfs"
    "minix"
    "nilfs2"
    "omfs"
    "qnx4"
    "qnx6"
    "sysv"
  ];

  # So we don't have to do this later...
  security.acme = {
    acceptTerms = true;
    defaults.email = "yavornkolev@gmail.com";
  };
}
