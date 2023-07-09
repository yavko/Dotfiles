{
  pkgs,
  config,
  ...
}: {
  home.packages = [pkgs.nwg-bar];
  xdg.configFile."nwg-bar/bar.json".text = builtins.toJSON [
    #{
    #  label = "Lock";
    #  exec = "swaylock -f -c 000000";
    #  icon = "/nix/store/wngcj1y46w7lhhf2mx74yvak148yz2pp-nwg-bar-0.1.3/share/nwg-bar/images/system-lock-screen.svg";
    #}
    {
      label = "Logout";
      exec = "hyprctl dispatch exit";
      icon = "${config.gtk.iconTheme.package}/share/icons/Papirus-Dark/symbolic/actions/system-log-out-symbolic.svg";
    }
    {
      label = "Reboot";
      exec = "systemctl reboot";
      icon = "${config.gtk.iconTheme.package}/share/icons/Papirus-Dark/symbolic/actions/system-reboot-symbolic.svg";
    }
    {
      label = "Shutdown";
      exec = "systemctl -i poweroff";
      icon = "${config.gtk.iconTheme.package}/share/icons/Papirus-Dark/symbolic/actions/system-shutdown-symbolic.svg";
    }
  ];
  xdg.configFile."nwg-bar/style.css".text = let
    inherit (import ./colors.nix) bg fg overlay0;
  in ''
    window {
            background-color: ${bg};
    }

    /* Outer bar container, takes all the window width/height */
    #outer-box {
    	margin: 0px;
    }

    /* Inner bar container, surrounds buttons */
    #inner-box {
    	background-color: ${bg}55;
    	border-radius: 10px;
    	border-style: none;
    	border-width: 1px;
    	border-color: ${overlay0}46;
    	padding: 5px;
    	margin: 5px;
    }

    button, image {
    	background: none;
    	border: none;
    	box-shadow: none;
    }

    button {
    	padding-left: 10px;
    	padding-right: 10px;
    	margin: 5px;
    }

    button:hover {
    	background-color: ${fg}0A;
    }
  '';
}
