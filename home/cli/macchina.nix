{
  pkgs,
  config,
  inputs,
  std,
  ...
}: let
  cat = import ./ascii.nix 1;
  cat-file = pkgs.writeTextFile {
    name = "cat-ascii";
    text = "\n\n${cat}";
  };
in {
  home.packages = with pkgs; [macchina];

  xdg.configFile."macchina/macchina.toml".text = std.serde.toTOML {
    theme = "custom";
    show = [
      "Host"
      "Distribution"
      "DesktopEnvironment"
      "Shell"
      "Terminal"
      "Uptime"
      #"Packages"
    ];
  };

  xdg.configFile."macchina/themes/custom.toml".text = std.serde.toTOML {
    # Hydrogen
    spacing = 2;
    padding = 0;
    hide_ascii = false;
    separator = "->";
    key_color = "Cyan";
    separator_color = "White";

    custom_ascii = {
      path = "${cat-file}";
      color = "Cyan";
    };

    palette = {
      type = "Full";
      visible = false;
    };
    bar = {
      glyph = "ߋ";
      symbol_open = "[";
      symbol_close = "]";
      hide_delimiters = true;
      visible = true;
    };
    box = {
      border = "rounded";
      visible = true;
      inner_margin = {
        x = 1;
        y = 0;
      };
    };

    randomize = {
      key_color = false;
      separator_color = false;
    };

    keys = {
      host = "Host";
      kernel = "Kernel";
      battery = "Battery";
      os = "OS";
      de = "Compositor";
      wm = "WM";
      distro = "Distro";
      terminal = "Terminal";
      shell = "Shell";
      packages = "Packages";
      uptime = "Uptime";
      memory = "Memory";
      machine = "Machine";
      local_ip = "Local IP";
      backlight = "Brightness";
      resolution = "Resolution";
      cpu_load = "CPU Load";
      cpu = "CPU";
    };
  };
}
