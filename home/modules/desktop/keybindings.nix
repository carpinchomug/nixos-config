{ cfg, config, lib, pkgs, wayland }:

let
  inherit (config.wayland.windowManager.sway.config) left down up right;

  brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";

  emacs =
    if config.services.emacs.enable
    then "${config.services.emacs.package}/bin/emacsclient -c"
    else if config.programs.emacs.enable
    then "${config.programs.emacs.finalPackage}/bin/emacs"
    else "${pkgs.emacs}/bin/emacs";

  flameshot = "${config.services.flameshot.package}/bin/flameshot";

  firefox =
    if config.programs.firefox.enable
    then "${config.programs.firefox.package}/bin/firefox"
    else "${pkgs.firefox}/bin/firefox";

in
{
  #
  # Basics:
  #

  # Start a terminal
  "${cfg.config.modifier}+Return" = "exec ${cfg.config.terminal}";

  # Kill focused window
  "${cfg.config.modifier}+Shift+q" = "kill";

  # Start your launcher
  "${cfg.config.modifier}+d" = "exec ${cfg.config.menu}";

  # Reload the configuration file
  "${cfg.config.modifier}+Shift+c" = "reload";

  # Exit sway (logs you out of your Wayland session)
  "${cfg.config.modifier}+Shift+e" =
    if wayland
    then "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'"
    else "exec i3-nagbar -t warning -m 'Do you want to exit i3?' -b 'Yes' 'i3-msg exit'";

  # Start emacs
  "${cfg.config.modifier}+Shift+Return" = "exec ${emacs}";

  # Start firefox
  "${cfg.config.modifier}+b" = "exec ${firefox}";

  # Brightness control
  "XF86MonBrightnessDown" = "exec ${brightnessctl} set 5%-";
  "XF86MonBrightnessUp" = "exec ${brightnessctl} set +5%";
} // (if wayland then {
  "XF86AudioMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
  "XF86AudioLowerVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- -l 1.2";
  "XF86AudioRaiseVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ -l 1.2";
  "XF86AudioMicMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
} else {
  "XF86AudioMute" = "exec pactl set-sink-mute 0 toggle";
  "XF86AudioRaiseVolume" = "exec pactl set-sink-volume 0 +5%";
  "XF86AudioLowerVolume" = "exec pactl set-sink-volume 0 -5%";
  "XF86AudioMicMute" = "exec pactl set-source-mute 0 toggle";
}) //
lib.warnIfNot config.services.flameshot.enable "Flameshot not enabled"
  lib.optionalAttrs
  config.services.flameshot.enable
  {
    # Start the Flameshot screenshot tool and take a screenshot
    "Print" = "exec ${flameshot} gui --path $(xdg-user-dir PICTURES)/Screenshots";
    # Wait for 3 seconds, then start the Flameshot screenshot tool and take a screenshot
    "Ctrl+Print" = "exec ${flameshot} gui --delay 3000 --path $(xdg-user-dir PICTURES)/Screenshots";
    # Take a full-screen (all monitors) screenshot and save it
    "Shift+Print" = "exec ${flameshot} full --path $(xdg-user-dir PICTURES)/Screenshots";
    # Take a full-screen (all monitors) screenshot and copy it to the clipboard and ask where to save
    "Ctrl+Shift+Print" = "exec ${flameshot} full --clipboard";
  } // {
  #
  # Moving around:
  #

  # Move your focus around
  "${cfg.config.modifier}+${left}" = "focus left";
  "${cfg.config.modifier}+${down}" = "focus down";
  "${cfg.config.modifier}+${up}" = "focus up";
  "${cfg.config.modifier}+${right}" = "focus right";
  # Or use $mod+[up|down|left|right]
  "${cfg.config.modifier}+Left" = "focus left";
  "${cfg.config.modifier}+Down" = "focus down";
  "${cfg.config.modifier}+Up" = "focus up";
  "${cfg.config.modifier}+Right" = "focus right";

  # Move the focused window with the same, but add Shift
  "${cfg.config.modifier}+Shift+${left}" = "move left";
  "${cfg.config.modifier}+Shift+${down}" = "move down";
  "${cfg.config.modifier}+Shift+${up}" = "move up";
  "${cfg.config.modifier}+Shift+${right}" = "move right";
  # Ditto, with arrow keys
  "${cfg.config.modifier}+Shift+Left" = "move left";
  "${cfg.config.modifier}+Shift+Down" = "move down";
  "${cfg.config.modifier}+Shift+Up" = "move up";
  "${cfg.config.modifier}+Shift+Right" = "move right";

  #
  # Workspaces:
  #

  # Switch to workspace
  "${cfg.config.modifier}+1" = "workspace number 1";
  "${cfg.config.modifier}+2" = "workspace number 2";
  "${cfg.config.modifier}+3" = "workspace number 3";
  "${cfg.config.modifier}+4" = "workspace number 4";
  "${cfg.config.modifier}+5" = "workspace number 5";
  "${cfg.config.modifier}+6" = "workspace number 6";
  "${cfg.config.modifier}+7" = "workspace number 7";
  "${cfg.config.modifier}+8" = "workspace number 8";
  "${cfg.config.modifier}+9" = "workspace number 9";
  # Move focused container to workspace
  "${cfg.config.modifier}+Shift+1" = "move container to workspace number 1";
  "${cfg.config.modifier}+Shift+2" = "move container to workspace number 2";
  "${cfg.config.modifier}+Shift+3" = "move container to workspace number 3";
  "${cfg.config.modifier}+Shift+4" = "move container to workspace number 4";
  "${cfg.config.modifier}+Shift+5" = "move container to workspace number 5";
  "${cfg.config.modifier}+Shift+6" = "move container to workspace number 6";
  "${cfg.config.modifier}+Shift+7" = "move container to workspace number 7";
  "${cfg.config.modifier}+Shift+8" = "move container to workspace number 8";
  "${cfg.config.modifier}+Shift+9" = "move container to workspace number 9";
  # Note: workspaces can have any name you want, not just numbers.
  # We just use 1-10 as the default.

  #
  # Layout stuff:
  #

  # You can "split" the current object of your focus with
  # $mod+b or $mod+v, for horizontal and vertical splits
  # respectively.
  "${cfg.config.modifier}+underscore" = "splith";
  "${cfg.config.modifier}+minus" = "splitv";

  # Switch the current container between different layout styles
  "${cfg.config.modifier}+s" = "layout stacking";
  "${cfg.config.modifier}+t" = "layout tabbed";
  "${cfg.config.modifier}+e" = "layout toggle split";

  # Make the current focus fullscreen
  "F11" = "fullscreen";

  # Toggle the current focus between tiling and floating mode
  "${cfg.config.modifier}+Shift+space" = "floating toggle";

  # Swap focus between the tiling area and the floating area
  "${cfg.config.modifier}+space" = "focus mode_toggle";

  # Move focus to the parent container
  "${cfg.config.modifier}+a" = "focus parent";

  #
  # Scratchpad:
  #

  # Sway has a "scratchpad", which is a bag of holding for windows.
  # You can send windows there and get them back later.

  # Move the currently focused window to the scratchpad
  "${cfg.config.modifier}+Shift+0" = "move scratchpad";

  # Show the next scratchpad window or hide the focused scratchpad window.
  # If there are multiple scratchpad windows, this command cycles through them.
  "${cfg.config.modifier}+0" = "scratchpad show";

  #
  # Resizing containers:
  #

  # Enter resize mode
  "${cfg.config.modifier}+r" = "mode resize";
}
