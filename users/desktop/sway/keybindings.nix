{ config, lib, pkgs, ... }:

let
  cfg = config.wayland.windowManager.sway.config;
  mod = cfg.modifier;

in
{
  wayland.windowManager.sway = {
    config = {
      keybindings = lib.mkOptionDefault {
        # Default keybindings are commented out

        # basics
        # "${mod}+Return" = "exec ${cfg.terminal}";
        # "${mod}+d" = "exec ${cfg.menu}";
        "${mod}+b" = "exec firefox";

        # "${mod}+Shift+q" = "kill";

        # "${mod}+Shift+c" = "reload";
        # "${mod}+Shift+e" = "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -B 'Yes, exit sway' 'swaymsg exit'";


        # layout

        # to be consistent with vim split keybindings
        "${mod}+s" = "splitv";
        "${mod}+v" = "splith";

        "${mod}+t" = "layout tabbed";
        "${mod}+w" = "layout toggle split";

        # "${mod}+a}" = "focus parent";

        # workspace        
        "${mod}+Shift+Return" = "workspace number 0";
        "${mod}+1" = "workspace number 1";
        "${mod}+2" = "workspace number 2";
        "${mod}+3" = "workspace number 3";
        "${mod}+4" = "workspace number 4";
        "${mod}+5" = "workspace number 5";
        "${mod}+6" = "workspace number 6";
        "${mod}+7" = "workspace number 7";
        "${mod}+8" = "workspace number 8";
        "${mod}+9" = "workspace number 9";
        "${mod}+0" = "workspace number 10";
        # Move focused container to workspace
        "${mod}+Shift+1" =  "move container to workspace number 1";
        "${mod}+Shift+2" =  "move container to workspace number 2";
        "${mod}+Shift+3" =  "move container to workspace number 3";
        "${mod}+Shift+4" =  "move container to workspace number 4";
        "${mod}+Shift+5" =  "move container to workspace number 5";
        "${mod}+Shift+6" =  "move container to workspace number 6";
        "${mod}+Shift+7" =  "move container to workspace number 7";
        "${mod}+Shift+8" =  "move container to workspace number 8";
        "${mod}+Shift+9" =  "move container to workspace number 9";
        "${mod}+Shift+0" =  "move container to workspace number 10";

        # audio control
        "XF86AudioMute" = "exec pamixer --toggle";
        "XF86AudioRaiseVolume" = "exec pamixer --increase 5";
        "XF86AudioLowerVolume" = "exec pamixer --decrease 5";
        "XF86AudioMicMute" = "exec pamixer --default-source --toggle";
        # "XF86AudioMute" = "exec 'pactl set-sink-mute @DEFAULT_SINK@ toggle'";
        # "XF86AudioRaiseVolume" = "exec 'pactl set-sink-volume @DEFAULT_SINK@ +1%'";
        # "XF86AudioLowerVolume" = "exec 'pactl set-sink-volume @DEFAULT_SINK@ -1%'";
        # "XF86AudioMicMute" = "exec 'pactl set-source-mute @DEFAULT_SOURCE@ toggle'";


        # brightness
        "XF86MonBrightnessDown" = "exec brightnessctl set 5%-";
        "XF86MonBrightnessUp" = "exec brightnessctl set +5%";


        # screenshot
        "${mod}+Print" = ''
          exec grim \
               ~/Pictures/Screenshots/$(date "+%Y%m%d_%Hh%Mm%Ss_grim.png")
        '';
        "${mod}+Alt+Print" = ''
          exec grim -g "$(slurp)" \
               ~/Pictures/Screenshots/$(date "+%Y%m%d_%Hh%Mm%Ss_grim.png")
        '';
      };
    };
  };
}
