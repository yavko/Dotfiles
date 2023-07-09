{
  config,
  lib,
  pkgs,
  ...
}: {
  systemd.user.services.ironbar.Service.Environment = "RUST_BACKTRACE=full";
  programs.ironbar = {
    enable = true;
    config = let
      workspaces = {
        type = "workspaces";
        all_monitors = false;
        favorites = map (n: builtins.toString n) [1 2 3 4 5 6 7 8 9 10];
        hidden = ["special"];
        name_map = let
          workspaces = lib.genAttrs (map (n: builtins.toString n) [1 2 3 4 5 6 7 8 9 10]);
          mkColorfull = text: color: "${text}"; # "<span foreground=\"${color}\">${text}</span>";
          dotify = _: mkColorfull "●";
          c = builtins.mapAttrs dotify (import ../colors.nix).base;
        in
          workspaces (
            i:
              if i == "1"
              then c.red
              else if i == "2"
              then c.maroon
              else if i == "3"
              then c.peach
              else if i == "4"
              then c.yellow
              else if i == "5"
              then c.green
              else if i == "6"
              then c.teal
              else if i == "7"
              then c.sky
              else if i == "8"
              then c.sapphire
              else if i == "9"
              then c.blue
              else if i == "10"
              then c.lavender
              else c.mauve
          );
      };

      music = let
        state_path = "${config.xdg.stateHome}/music-ctrls-state";
        show-script = pkgs.writeShellApplication {
          name = "mctrls-shower";
          runtimeInputs = with pkgs; [coreutils];
          text = ''
            ${pkgs.coreutils}/bin/touch ${state_path}
            out=$(< ${state_path})
            if [[ $out != "show" ]]; then
              echo -ne "show" > ${state_path}
            fi
          '';
        };
        hide-script = pkgs.writeShellApplication {
          name = "mctrls-hider";
          runtimeInputs = with pkgs; [coreutils];
          text = ''
            ${pkgs.coreutils}/bin/touch ${state_path}
            out=$(< ${state_path})
            if [[ $out == "show" ]]; then
              echo -ne "" >${state_path}
            fi
          '';
        };
      in {
        type = "music";
        player_type = "mpris";
        format = "{title}";
        truncate = "end";
        #icons.play = "icon:media-playback-start";
        #icons.pause = "icon:media-playback-pause";
        music_dir = config.xdg.userDirs.music;
        show_status_icon = false;
        on_mouse_enter.cmd = "${show-script}/bin/mctrls-shower";
        on_mouse_exit.cmd = "${hide-script}/bin/mctrls-hider";
        #icon_size = 64;
        #cover_image_size = 256;
      };
      music_img = rec {
        type = "custom";
        name = "music-img";
        class = name;
        on_mouse_enter = music.on_mouse_enter;
        on_mouse_exit = music.on_mouse_exit;
        bar = [
          {
            type = "image";
            class = name + "-img";
            #src = ''{{poll:5000:${pkgs.playerctl}/bin/playerctl metadata mpris:artUrl}}'';
            src = ''{{watch:${pkgs.playerctl}/bin/playerctl -F metadata mpris:artUrl}}'';
          }
        ];
      };
      music_inline_controls = let
        check-script = pkgs.writeShellApplication {
          name = "mctrls-checker";
          runtimeInputs = with pkgs; [coreutils];
          text = let
            state_path = "${config.xdg.stateHome}/music-ctrls-state";
          in ''
            ${pkgs.coreutils}/bin/touch ${state_path}
            if [[ $(< ${state_path}) == "show" ]]; then
            	exit 0
            else
            	exit 1
            fi
          '';
        };
        play-icon-script = pkgs.writeShellApplication {
          name = "pp-icon";
          runtimeInputs = [pkgs.playerctl];
          text = ''
            if [[ $(${pkgs.playerctl}/bin/playerctl status) == "Playing" ]]; then
            	echo ""
            else
            	echo ""
            fi
          '';
        };
      in rec {
        type = "custom";
        name = "music-ctrls";
        class = name;
        show_if = {
          mode = "poll";
          interval = 1000;
          cmd = "${check-script}/bin/mctrls-checker";
        };
        on_mouse_enter = music.on_mouse_enter;
        on_mouse_exit = music.on_mouse_exit;
        transition_type = "slide_start";
        bar = let
          pctl = cmd:
            "!"
            + (pkgs.writeShellApplication {
              name = "iron-${cmd}";
              runtimeInputs = [pkgs.playerctl];
              text = "${pkgs.playerctl}/bin/playerctl ${cmd}";
            })
            + "/bin/iron-${cmd}";
        in [
          {
            type = "button";
            class = name + "-prev";
            label = "󰒮";
            on_click = pctl "previous";
          }
          {
            type = "button";
            class = name + "-pp";
            label = "{{poll:100:${play-icon-script}/bin/pp-icon}}";
            on_click = pctl "play-pause";
          }
          {
            type = "button";
            class = name + "-next";
            label = "󰒭";
            on_click = pctl "next";
          }
        ];
      };
      sys_info = {
        type = "sys_info";
        format = [" {cpu_percent}%" " {memory_percent}%"];
      };
      battery = {
        type = "upower";
        format = "{percentage}%";
      };

      tray = {type = "tray";};
      clock = {
        type = "clock";
        format = "%l:%M %P";
      };

      cava = {
        type = "script";
        mode = "watch";
        cmd =
          (pkgs.writeShellApplication {
            name = "cava";
            runtimeInputs = [pkgs.cava pkgs.gnused];
            text = ''
              printf "[general]\nframerate=160\nbars = 7\n[output]\nmethod = raw\nraw_target = /dev/stdout\ndata_format = ascii\nascii_max_range = 7\n" | cava -p /dev/stdin | sed -u 's/;//g;s/0/▁/g;s/1/▂/g;s/2/▃/g;s/3/▄/g;s/4/▅/g;s/5/▆/g;s/6/▇/g;s/7/█/g; '
            '';
          })
          + "/bin/cava";
      };
      dash = rec {
        type = "custom";
        name = "nix-launcher";
        class = name;
        bar = [
          {
            type = "button";
            label = "󰇙   ";
            on_click = "popup:toggle";
          }
        ];
        popup = [
          {
            type = "box";
            orientation = "v";
            widgets = [
              #{
              #  type = "label";
              #  label = "{{${pkgs.macchina}/bin/macchina}}";
              #}
              {
                type = "box";
                widgets = [
                  {
                    type = "button";
                    label = "󱗼 Applications";
                    on_click = "!${pkgs.rofi}/bin/rofi -show drun";
                  }
                  {
                    type = "button";
                    label = "󰕾 Sound";
                    on_click = "!${pkgs.pavucontrol}/bin/pavucontrol";
                  }
                  {
                    type = "button";
                    label = "󰐥 Power";
                    on_click = "!${pkgs.nwg-bar}/bin/nwg-bar";
                  }
                ];
              }
            ];
          }
        ];
      };

      left = [
        #focused
        dash
        workspaces
      ];
      right = [
        #tray
        #sys_info
        cava
        battery
        clock
      ];
      center = [
        music_img
        music
        music_inline_controls
      ];
    in {
      anchor_to_edges = true;
      position = "top";
      start = left;
      end = right;
      center = center;
      #center = [
      #  {
      #    type = "label";
      #    label = "random num: {{500:playerctl metadata mpris:artUrl}}";
      #  }
      #];
      height = 32;
      icon_theme = config.gtk.iconTheme.name;
    };
    style = let
      built = pkgs.callPackage ./scss-pkg.nix {
        src = ./styles;
        entry = "main";
      };
    in ''
      @import url("${built}/out.css");
    '';
  };
}
