{ config, pkgs, ... }:

let
  wallpaper = builtins.toString config.xdg.configHome + "/wallpapers/serenity.png";

in
{
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    xwayland = true;

    config = {
      modifier = "Mod4";
      terminal = "foot";
      menu = "wofi --show run | xargs swaymsg exec --";
      bars = [ ];
      # bars = [
      #   {
      #     position = "top";
      #     fonts = {
      #       names = [ "Noto Sans" "Noto Sans CJK JP" "NotoSans Nerd Font" ];
      #       size = 12.0;
      #     };
      #     statusCommand = "i3status-rs ~/.config/i3status-rust/config-default.toml";
      #     extraConfig = ''
      #       tray {
      #         icon_theme Papirus-Dark
      #       }
      #     '';
      #   }
      # ];

      input = {
        "type:keyboard" = {
          xkb_layout = "us";
          # xkb_options = "ctrl:swapcaps";
        };

        "type:touchpad" = {
          tap = "enabled";
          natural_scroll = "enabled";
          scroll_factor = "0.7";
        };
      };

      output = {
        eDP-1.bg = "${wallpaper} fill";
        HDMI-A-1.bg = "${wallpaper} fill";
      };

      workspaceOutputAssign = [
        {
          output = "HDMI-A-1";
          workspace = "10";
        }
      ];

      fonts = {
        names = [ "Noto Sans" "Noto Sans CJK JP" "NotoSans Nerd Font" ];
        size = 12.0;
      };

      gaps = {
        inner = 10;
      };

      window = {
        border = 3;

        commands = [
          {
            command = "inhibit_idle fullscreen";
            criteria = {
              workspace = "__focused__";
            };
          }
        ];
      };

      colors = {
        focused = {
          border = "#191724";
          background = "#191724";
          text = "#e0def4";
          indicator = "#9ccfd8";
          childBorder = "#31748f";
        };
        focusedInactive = {
          border = "#191724";
          background = "#191724";
          text = "#e0def4";
          indicator = "#524f67";
          childBorder = "#26233a";
        };
        unfocused = {
          border = "#191724";
          background = "#191724";
          text = "#6e6a86";
          indicator = "#524f67";
          childBorder = "#26233a";
        };
        urgent = {
          border = "#191724";
          background = "#191724";
          text = "#eb6f92";
          indicator = "#524f67";
          childBorder = "#26233a";
        };
      };

      startup = [
        {
          command = ''
            swayidle -w \
            timeout 300 'swaylock -f -c 000000' \
            timeout 600 'swaymsg "output * dpms off"' resume 'swaymsg "output * dpms on"' \
            before-sleep 'swaylock -f -c 000000'
          '';
        }

        {
          command = ''
            systemctl --user import-environment DISPLAY WAYLAND_DISPLAY SWAYSOCK
          '';
        }

        {
          command = ''
            hash dbus-update-activation-environment 2>/dev/null && \
            dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK
          '';
        }
        {
          command = ''
            kmonad ~/.config/kmonad/config.kbd
          '';
        }
        {
          command = ''
            exec env RUST_BACKTRACE=1 RUST_LOG=swayr=debug swayrd > /tmp/swayrd.log 2>&1
          '';
        }
      ];
    };

    extraSessionCommands = ''
      if [[ ! -d ~/Pictures/Screenshots ]]; then
        mkdir -p ~/Pictures/Screenshots
      fi
    '';
  };
}
