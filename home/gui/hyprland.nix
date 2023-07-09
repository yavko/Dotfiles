{
  config,
  nix-colors,
  pkgs,
  ...
} @ args: let
  xargb = c: "88${c}";
  x = config.colorScheme.colors;
  shader_path = pkgs.writeTextFile {
    name = "filter_colors.frag";
    text = import ./cat-mocha.frag.nix args;
  };
  toggle_script = pkgs.writeShellApplication {
    name = "shader_toggler";
    runtimeInputs = with pkgs; [jaq];
    text = ''
      shader=$(hyprctl getoption decoration:screen_shader -j | jaq ".str")
      if [[ $shader == "\"[[EMPTY]]\"" ]]; then
      	hyprctl keyword decoration:screen_shader "${shader_path}"
      else
      	hyprctl keyword decoration:screen_shader "[[EMPTY]]"
      fi
    '';
  };
  sosd = arg: val: "${pkgs.swayosd}/bin/swayosd --${arg} ${val}";
in ''
  # Variables
  $mod = SUPER

  # Display stuff
  monitor = eDP-1, highres, auto, 2

   general {
     gaps_in = 5
     gaps_out = 5
     border_size = 2
     col.active_border = 0x${xargb x.base06} # white
     col.inactive_border = 0x${xargb x.base02} # black
   }

       decoration {
         rounding = 16
         blur = false
         drop_shadow = 1
         shadow_ignore_window = 1
         shadow_offset = 0 5
         shadow_range = 50
         shadow_render_power = 3
         col.shadow = rgba(00000099)
         #screen_shader = ${shader_path}
       }

       animations {
         enabled = 1
         animation = border, 1, 2, default
         animation = fade, 1, 4, default
         animation = windows, 1, 3, default, popin 80%
         animation = workspaces, 1, 2, default, slide
       }

       # Window rules
       windowrulev2 = float, title:^(Picture-in-Picture)$
       windowrulev2 = pin, title:^(Picture-in-Picture)$

       windowrulev2 = workspace special silent, title:^(Firefox — Sharing Indicator)$
       windowrulev2 = workspace special silent, title:^(.*is sharing (your screen|a window)\.)$

  	 # fix xwayland apps
  	 windowrulev2 = rounding 0, xwayland:1, floating:1
  		# Mouse binds
  		bindm = $mod, mouse:272, movewindow
  		bindm = $mod, mouse:273, resizewindow

  		# Key bindings
  		bind = $mod, Q , exec, kitty
  		bind = $mod, C, killactive
  		bind = $mod, R, exec, zsh -c 'rofi -show drun'
  		bind = $mod, M, exit
  		bind = $mod, V, togglefloating
  		bind = $mod SHIFT, equal, exec, ${toggle_script}/bin/shader_toggler


  	# control windows
  	general:layout = hy3
  	bind = $mod, W,submap,windowctl
  	submap = windowctl

  	bind=,v,hy3:makegroup,v
  	bind=,v,submap,reset

  	bind=,right,hy3:movefocus,right
  	bind=,right,submap,reset

  	bind=,left,hy3:movefocus,left
  	bind=,left,submap,reset

  	bind=,up,hy3:movefocus,up
  	bind=,up,submap,reset

  	bind=,down,hy3:movefocus,down
  	bind=,down,submap,reset

  	bind=,s,hy3:makegroup,h
  	bind=,s,submap,reset

  	submap = reset

       # media controls
       bindl = , XF86AudioPlay, exec, playerctl -a play-pause
       bindl = , XF86AudioPrev, exec, playerctl previous
       bindl = , XF86AudioNext, exec, playerctl next

       # volume
       bindle = , XF86AudioRaiseVolume, exec,${sosd "output-volume" "+6"}
       bindle = , XF86AudioLowerVolume,exec,${sosd "output-volume" "-6"}
       bindl = , XF86AudioMute, exec,${sosd "output-volume" "mute-toggle"}
       bindl = , XF86AudioMicMute, exec,${sosd "input-volume" "mute-toggle"}

       # backlight
       bindle = , XF86MonBrightnessUp, exec,${sosd "brightness" "+10"}
       bindle = , XF86MonBrightnessDown, exec,${sosd "brightness" "-10"}

       # cAPS lOCK
       bindr = , Caps_Lock, exec,${sosd "caps-lock" ""}

  	 # screenshot
       $screenshotarea = hyprctl keyword animation "fadeOut,0,0,default"; grimblast --notify copysave area; hyprctl keyword animation "fadeOut,1,4,default"
       bind = , Print, exec, $screenshotarea
       #bind = $mod SHIFT, R, exec, $screenshotarea
       #bind = CTRL, Print, exec, grimblast --notify --cursor copysave output
       #bind = $mod SHIFT CTRL, R, exec, grimblast --notify --cursor copysave output
       #bind = ALT, Print, exec, grimblast --notify --cursor copysave screen
       #bind = $mod SHIFT ALT, R, exec, grimblast --notify --cursor copysave screen

   	  # workspaces
   		${builtins.concatStringsSep "\n" (builtins.genList (
      x: let
        ws = let
          c = (x + 1) / 10;
        in
          builtins.toString (x + 1 - (c * 10));
      in ''
        bind = $mod, ${ws}, workspace, ${toString (x + 1)}
        bind = ALT, ${ws}, movetoworkspace, ${toString (x + 1)}
      ''
    )
    10)}
''
