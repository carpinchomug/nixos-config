{
  programs.waybar = {
    enable = true;

    settings = [
      {
        layer = "top";
        position = "top";
        height = 28;

        modules-left = [ "sway/workspaces" "sway/window" ];
        modules-center = [ "clock" ];
        modules-right = [
          # "network"
          # "cpu"
          # "memory"
          "idle_inhibitor"
          "pulseaudio"
          "backlight"
          "battery"
          "tray"
          "custom/power"
        ];

        "sway/workspaces" = {
          format = "{icon}";
          format-icons = {
            "0" = "";
            "10" = "﴿";
          };
        };

        clock = {
          # format = "{:%a %e %b %H:%M}";
          format = "{:%H:%M}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt>{calendar}</tt>";
        };

        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
        };

        pulseaudio = {
          format = "{volume}% {icon}";
          format-muted = "";
          format-bluetooth = "{volume}% {icon}";
          format-bluetooth-muted = "";
          format-icons = {
            headphone = "";
            default = [ "" "" "" ];
          };
          on-click = "pavucontrol";
        };

        # network = {
        #   format = "{ifname}";
        #   format-wifi = "{signalStrength}% ";
        #   format-ethernet = "{ipaddr}/{cidr} ";
        #   format-disconnected = ""; # An empty format will hide the module
        #   tooltip-format = "{ifname} via {gwaddr} ";
        #   tooltip-format-wifi = "{essid}";
        # };
        #
        # cpu = {
        #   format = "{usage}% ";
        #   tooltip = false;
        # };
        #
        # memory = {
        #   format = "{percentage}% ";
        #   tooltip = false;
        # };

        backlight = {
          format = "{percent}% {icon}";
          format-icons = [ "" "" "" "" "" "" "" "" "" ];
        };

        battery = {
          states = {
            critical = 20;
            warning = 30;
          };
          format = "{capacity}% {icon}";
          format-critical = "{capacity}% <span color='#e01b24'>{icon}</span>";
          format-warning = "{capacity}% <span color='#ff7800'>{icon}</span>";
          format-charging = "{capacity}% <span color='#2ec27e'>{icon}</span>";
          format-plugged = "{capacity}% ";

          format-icons = [ "" "" "" "" "" ];
        };

        tray = {
          spacing = 10;
        };

        "custom/power" = {
          format = "";
          on-click = "wlogout";
        };
      }
    ];

    style = ''
      ${builtins.readFile ./style.css}
    '';
  };
}
