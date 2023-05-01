{
  config,
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [libsForQt5.breeze-icons];
  programs.ironbar = {
    enable = true;
    features = [
      "http"
      "config+json"
      "clipboard"
      "clock"
      "music+all"
      "sys_info"
      "tray"
      "workspaces+hyprland"
    ];
    config = let
      workspaces = {
        type = "workspaces";
        all_monitors = false;
        name_map = let
          workspaces = lib.genAttrs (map (n: builtins.toString n) [1 2 3 4 5 6 7 8 9 10]);
          #fire = "";
          #term = "";
          #music = "󰎈";
        in
          workspaces (_: "●");
      };

      music = let
        state_path = "${config.xdg.stateHome}/music-ctrls-state";
        show-script = pkgs.writeShellApplication {
          name = "mctrls-shower";
          text = ''
            touch ${state_path}
            out=$(< ${state_path})
            if [[ $out != "show" ]]; then
              echo -ne "show" > ${state_path}
            fi
          '';
        };
        hide-script = pkgs.writeShellApplication {
          name = "mctrls-hider";
          text = ''
            touch ${state_path}
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
        icons.play = "icon:media-playback-start";
        icons.pause = "icon:media-playback-pause";
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
            src = ''{{poll:5000:playerctl metadata mpris:artUrl}}'';
            #src = ''{{watch:playerctl -F metadata mpris:artUrl}}'';
          }
        ];
      };
      music_inline_controls = let
        check-script = pkgs.writeShellApplication {
          name = "mctrls-checker";
          text = let
            state_path = "${config.xdg.stateHome}/music-ctrls-state";
          in ''
            touch ${state_path}
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
          interval = 500;
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
            label = "玲";
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
            label = "怜";
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

      power_button = {
        type = "button";
        name = "power-btn";
        label = "";
        #src = "icon:system-shutdown-symbolic";
        on_click = "popup:toggle";
      };

      up_full = let
        uptime-script = pkgs.writeShellApplication {
          name = "fmt-uptime";
          text = ''
            all=$(uptime | sed -E 's/.+up  //gm;t;d' | sed -E 's/,.+//gm;t;d')
            m=$(sed -E 's/.*://gm;t;d' <<< "$all")
            h=$(sed -E 's/:.*//gm;t;d' <<< "$all")
            echo -ne "$h Hours, $m Minutes"
          '';
        };
      in "{{30000:${uptime-script}/bin/fmt-uptime}}";

      power_popup = {
        type = "box";
        orientation = "vertical";
        widgets = [
          {
            type = "label";
            name = "header";
            label = "Power menu";
          }
          {
            type = "box";
            widgets = [
              {
                type = "button";
                class = "power-btn";
                label = "<span font-size='40pt'></span>";
                on_click = "!shutdown now";
              }
              {
                type = "button";
                class = "power-btn";
                label = "<span font-size='40pt'></span>";
                on_click = "!reboot";
              }
            ];
          }
          {
            type = "label";
            name = "uptime";
            label = "Uptime: ${up_full}";
          }
        ];
      };

      power_menu = {
        type = "custom";
        class = "power-menu";

        bar = [power_button];
        popup = [power_popup];

        tooltip = "Up: ${up_full}";
      };

      nix_launch = rec {
        type = "custom";
        name = "nix-launcher";
        class = name;
        bar = [
          {
            type = "button";
            label = "";
            on_click = "!hyprctl dispatch exec \"zsh -c 'rofi -show drun'\"";
          }
        ];
      };

      left = [
        #focused
        nix_launch
        workspaces
      ];
      right = [
        tray
        sys_info
        #battery
        power_menu
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
      #icon_theme = "breeze-dark";
    };
    style = let
      inherit ((import ./colors.nix).extra) fg bg red blue maroon subtext0 mantle overlay1;
    in ''
                     * {
                     /*all: unset;*/
                     /* `otf-font-awesome` is required to be installed for icons */
                     /*font-family: Noto Sans Nerd Font, sans-serif;*/
                     /*font-family: monospace;*/
                     font-family: Product Sans, Roboto, sans-serif;
                           font-size: 13px;
                           transition: 200ms ease;

                           /*color: ${fg};*/
                           /*background-color: #2d2d2d;*/
                           /*background-color: ${bg};*/
                           border: none;

                           /*opacity: 0.4;*/
                       }

                       #bar {
                           /*border-top: 1px solid #424242;*/
                      /*height: 20px;*/
                       }

                       .container {
                           background-color: ${bg};
                       }

                       /* test  34543*/

                       #right > * + * {
                           margin-left: 20px;
                       }
                       #left > * + * {
                           margin-right: 10px;
                       }
      					 .nix-launcher button {
      		 all: unset;
      			background-color: ${bg};
      					 }
          .nix-launcher label {
      background-color: ${blue};
      color: ${bg};
      font-family: monospace;
      font-size: 1.5rem;
      padding: 0 1.1rem 0 .5rem;
          }


                   #workspaces {
      							all: unset;
      				margin-left: 10px;
                   }
                   #workspaces label {
             				font-family: Material Symbols Outlined;
      				font-size: 1.2rem;
                   }
                       #workspaces .item {
             							all: unset;
                           color: ${maroon};
                   				margin-right: 5px;
          					padding: 0px;
             							font-family: Material Symbols Outlined;
                       }

                       #workspaces .item.focused {
                           /*box-shadow: inset 0 -3px;*/
                           color: ${red};
                       }

                       #launcher .item {
                           border-radius: 0;
                           background-color: ${bg};
                           margin-right: 4px;
                       }

                       #launcher .item:not(.focused):hover {
                           background-color: ${mantle};
                       }

                       #launcher .open {
                           border-bottom: 2px solid ${blue};
                       }

                       #launcher .focused {
                           color: ${fg};
                           background-color: ${mantle};
                           border-bottom: 4px solid ${blue};
                       }

                       #launcher .urgent {
                           color: ${fg};
                           background-color: ${red};
                       }

                       #clock {
                           color: ${fg};
                           background-color: ${bg};
                           font-weight: bold;
                       }

                       #sysinfo {
                           color: ${fg};
                       }

                       #tray {
                          background-color: ${bg};
                       }

                       #tray .item {
                          background-color: ${bg};
      							-gtk-icon-effect: dim;
                       }

      								#music-img {
      						border-radius: 8px;
      						margin-right: 8px;
      								}
      					#music-ctrls {
      						all: unset;
      						margin-left: 5px;
      					}

                       #music {
                           background-color: ${bg};
                           color: ${fg};
                       }
                       #music label {
                      	font-size: 16px;
      					 }

                       .popup {
                           background-color: ${bg};
                           border: 1px solid ${subtext0};
                       }

                       #popup-clock {
                           padding: 1em;
                       }

                       #calendar-clock {
                           color: ${fg};
                           font-size: 2.5em;
                           padding-bottom: 0.1em;
                       }

                       #calendar {
                           background-color: ${bg};
                           color: ${fg};
                       }

                       #calendar .header {
                           padding-top: 1em;
                           border-top: 1px solid ${subtext0};
                           font-size: 1.5em;
                       }

                       #calendar:selected {
                           background-color: ${blue};
                       }

             					.power-menu {
                 				margin-left: 10px;
             					}

             					.power-menu #power-btn {
                 				color: ${fg};
                 				background-color: ${bg};
             					}

             					.power-menu #power-btn:hover {
                 				background-color: ${mantle};
             					}

             					.popup-power-menu {
                 				padding: 1em;
             					}

             					.popup-power-menu #header {
                 				color: ${fg};
                 				font-size: 1.4em;
                 				border-bottom: 1px solid ${overlay1};
                 				padding-bottom: 0.4em;
                 				margin-bottom: 0.8em;
             					}

             .popup-power-menu .power-btn {
                 color: ${fg};
                 background-color: ${bg};
                 border: 1px solid ${overlay1};
                 padding: 0.6em 1em;
             }

             .popup-power-menu .power-btn + .power-btn {
                 margin-left: 1em;
             }

             .popup-power-menu .power-btn:hover {
                 background-color: ${mantle};
             }

                       #music {
             							all: unset;
                           color: ${fg};
      							 font-size: 16px;
                       }

                       #popup-music #album-art {
                           margin-right: 1em;
                   	border-radius: 20px;
                       }

                       #popup-music #title .icon, #popup-mpd #title .label {
                           font-size: 1.7em;
                       }

                       #popup-music #controls * {
                           border-radius: 0;
                           background-color: transparent;
                           color: ${fg};
                       }

                       #popup-music #controls *:disabled {
                           color: ${overlay1};
                       }

                       #focused {
                           color: ${fg};
                       }
    '';
  };
}
