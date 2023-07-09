{pkgs, ...}: {
  programs.firejail = {
    enable = true;
    wrappedBinaries = {
      firefox = {
        executable = "${pkgs.lib.getBin pkgs.firefox}/bin/firefox";
        desktop = "${pkgs.firefox}/share/applications/firefox.desktop";
        profile = "${pkgs.firejail}/etc/firejail/firefox.profile";
      };
    };
  };
  environment.etc."firejail/firefox.local".text = ''
    dbus-user.talk org.freedesktop.Notifications
    dbus-user.talk org.freedesktop.ScreenSaver
    dbus-user.talk org.freedesktop.portal.Desktop
    ignore noroot
  '';
  #programs.firefox.enable = true;
  #programs.firefox.package = null;
  home-manager.users.yavor = {
    pkgs,
    lib,
    ...
  }: {
    # TODO: FIGURE OUT HOW TO USE HM MODULE WITH FIREJAIL

    programs.firefox = {
      #enable = true;
      profiles.default.extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        # lang packs & dicts
        french-dictionary
        french-language-pack
        bulgarian-dictionary

        metamask
        multi-account-containers
        side-view
        darkreader
        ublock-origin
        re-enable-right-click
        mailvelope
        violentmonkey
        auto-tab-discard
        # kde connect extension
        lovely-forks
        privacy-pass
        widegithub
        enhanced-github
        gitako-github-file-tree
        refined-github
        facebook-container # blocks facebook >:)
        canvasblocker
        #gnome-shell-integration (not using gnome ;-; )
        enhancer-for-youtube
        decentraleyes
        sponsorblock
        return-youtube-dislikes
        demodal
        nos2x-fox
        languagetool
        onetab
        mullvad
        bypass-paywalls-clean
        furiganaize
        firefox-translations
        octolinker
        tabliss
        notifier-for-github
        overbitewx
        vencord-web
        github-isometric-contributions
      ];
    };
  };
}
