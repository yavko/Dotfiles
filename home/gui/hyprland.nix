{
  config,
  nix-colors,
  ...
}: let
  xargb = c: "88${c}";
  x = config.colorScheme.colors;
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
         blur = 1
         blur_size = 3
         blur_passes = 3
         blur_new_optimizations = 1
         drop_shadow = 1
         shadow_ignore_window = 1
         shadow_offset = 2 2
         shadow_range = 4
         shadow_render_power = 1
         col.shadow = 0x55000000
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
       windowrulev2 = workspace silent special, title:^(Firefox — Sharing Indicator)$
       windowrulev2 = tile, title:^(.*is sharing (your screen|a window)\.)$
       windowrulev2 = workspace silent 10, title:^(.*is sharing (your screen|a window)\.)$

  		# Mouse binds
  		bindm = $mod, mouse:272, movewindow
  		bindm = $mod, mouse:273, resizewindow

  		# Key bindings
  		bind = $mod, Q , exec, kitty
  		bind = $mod, C, killactive
  		bind = $mod, R, exec, zsh -c 'rofi -show drun'
  		bind = $mod, M, exit
  		bind = $mod, V, togglefloating

       # media controls
       bindl = , XF86AudioPlay, exec, playerctl -a play-pause
       bindl = , XF86AudioPrev, exec, playerctl previous
       bindl = , XF86AudioNext, exec, playerctl next

       # volume
       bindle = , XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 6%+
       bindle = , XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 6%-
       bindl = , XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
       bindl = , XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle

       # backlight
       bindle = , XF86MonBrightnessUp, exec, brightnessctl s +10%
       bindle = , XF86MonBrightnessDown, exec, brightnessctl s 10%-

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
