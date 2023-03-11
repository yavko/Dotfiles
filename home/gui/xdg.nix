{
  pkgs,
  config,
  ...
}: let
  browser = ["firefox.desktop"];
	fm = ["pcmanfm.desktop"];
  # XDG MIME types
  associations = {
    "application/x-extension-htm" = browser;
    "application/x-extension-html" = browser;
    "application/x-extension-shtml" = browser;
    "application/x-extension-xht" = browser;
    "application/x-extension-xhtml" = browser;
    "application/xhtml+xml" = browser;
    "text/html" = browser;
    "x-scheme-handler/about" = browser;
    #"x-scheme-handler/chrome" = ["chromium-browser.desktop"];
    "x-scheme-handler/ftp" = browser;
    "x-scheme-handler/http" = browser;
    "x-scheme-handler/https" = browser;
    "x-scheme-handler/unknown" = browser;

		# File manager
		"inode/directory" = fm;
		"application/x-gnome-saved-search" = fm;

    "audio/*" = ["mpv.desktop"];
    "video/*" = ["mpv.dekstop"];
    "image/*" = ["imv.desktop"];
    "application/json" = browser;
    "application/pdf" = ["org.pwmt.zathura.desktop.desktop"];
  };
  h = config.home.homeDirectory;
in {
  home.packages = with pkgs; [xdg-utils];
  xdg = {
    enable = true;
    cacheHome = h + "/.local/cache";
    userDirs = {
      enable = true;
      createDirectories = true;
      extraConfig = {
        XDG_SCREENSHOTS_DIR = "${config.xdg.userDirs.pictures}/Screenshots";
      };
    };
    mimeApps = {
      enable = true;
      defaultApplications = associations;
    };
  };
}
