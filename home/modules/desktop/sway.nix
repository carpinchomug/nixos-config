{ config, pkgs, ... }:

let
  cfg = config.wayland.windowManager.sway;
  mod = cfg.config.modifier;

  configure-gtk = pkgs.writeTextFile {
    name = "configure-gtk";
    destination = "/bin/configure-gtk";
    executable = true;
    text =
      let
        schema = pkgs.gsettings-desktop-schemas;
        datadir = "${schema}/share/gsettings-schemas/${schema.name}";
        gsettings = "${pkgs.glib}/bin/gsettings";
      in
      ''
        export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
        gnome_schema=org.gnome.desktop.interface

        ${gsettings} set $gnome_schema gtk-theme ${config.gtk.theme.name}
        ${gsettings} set $gnome_schema icon-theme ${config.gtk.iconTheme.name}
        ${gsettings} set $gnome_schema cursor-theme ${config.gtk.cursorTheme.name}

        # For gtk4
        ${gsettings} set $gnome_schema color-scheme default
      '';
  };

in
{
  wayland.windowManager.sway = {
    enable = true;

    wrapperFeatures.gtk = true;

    config = {
      modifier = "Mod4";

      output = {
        "*" = {
          # default wallpaper
          bg = "${cfg.package}/share/backgrounds/sway/Sway_Wallpaper_Blue_1920x1080.png fill";
        };
      };

      seat = {
        "seat0" = {
          xcursor_theme = "${config.gtk.cursorTheme.name} ${builtins.toString config.gtk.cursorTheme.size}";
        };
      };

      gaps = {
        inner = 16;
      };

      window = {
        titlebar = false;
        border = 2;
      };

      floating = {
        border = 2;
      };

      startup = [
        {
          command = "${configure-gtk}/bin/configure-gtk";
          always = true;
        }
      ];

      keybindings = {
        #
        # Basics:
        #

        # Start a terminal
        "${mod}+Return" = "exec ${cfg.config.terminal}";

        # Kill focused window
        "${mod}+Shift+q" = "kill";

        # Start your launcher
        "${mod}+d" = "exec ${cfg.config.menu}";

        # Reload the configuration file
        "${mod}+Shift+c" = "reload";

        # Exit sway (logs you out of your Wayland session)
        "${mod}+Shift+e" = "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";

        # Start emacs
        "${mod}+Shift+Return" = "exec emacsclient -c";

        # Start firefox
        "${mod}+b" = "exec firefox";

        # Brightness control
        "XF86MonBrightnessDown" = "exec brightnessctl set 5%-";
        "XF86MonBrightnessUp" = "exec brightnessctl set +5%";

        # Audio control
        "XF86AudioMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        "XF86AudioLowerVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- -l 1.2";
        "XF86AudioRaiseVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ -l 1.2";
        "XF86AudioMicMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";

        # Start the Flameshot screenshot tool and take a screenshot
        "Print" = "exec flameshot gui --path $(xdg-user-dir PICTURES)/Screenshots";
        # Wait for 3 seconds, then start the Flameshot screenshot tool and take a screenshot
        "Ctrl+Print" = "exec flameshot gui --delay 3000 --path $(xdg-user-dir PICTURES)/Screenshots";
        # Take a full-screen (all monitors) screenshot and save it
        "Shift+Print" = "exec flameshot full --path $(xdg-user-dir PICTURES)/Screenshots";
        # Take a full-screen (all monitors) screenshot and copy it to the clipboard and ask where to save
        "Ctrl+Shift+Print" = "exec flameshot full --clipboard";

        #
        # Moving around:
        #

        # Move your focus around
        "${mod}+${cfg.config.left}" = "focus left";
        "${mod}+${cfg.config.down}" = "focus down";
        "${mod}+${cfg.config.up}" = "focus up";
        "${mod}+${cfg.config.right}" = "focus right";
        # Or use $mod+[up|down|left|right]
        "${mod}+Left" = "focus left";
        "${mod}+Down" = "focus down";
        "${mod}+Up" = "focus up";
        "${mod}+Right" = "focus right";

        # Move the focused window with the same, but add Shift
        "${mod}+Shift+${cfg.config.left}" = "move left";
        "${mod}+Shift+${cfg.config.down}" = "move down";
        "${mod}+Shift+${cfg.config.up}" = "move up";
        "${mod}+Shift+${cfg.config.right}" = "move right";
        # Ditto, with arrow keys
        "${mod}+Shift+Left" = "move left";
        "${mod}+Shift+Down" = "move down";
        "${mod}+Shift+Up" = "move up";
        "${mod}+Shift+Right" = "move right";

        #
        # Workspaces:
        #

        # Switch to workspace
        "${mod}+1" = "workspace number 1";
        "${mod}+2" = "workspace number 2";
        "${mod}+3" = "workspace number 3";
        "${mod}+4" = "workspace number 4";
        "${mod}+5" = "workspace number 5";
        "${mod}+6" = "workspace number 6";
        "${mod}+7" = "workspace number 7";
        "${mod}+8" = "workspace number 8";
        "${mod}+9" = "workspace number 9";
        # Move focused container to workspace
        "${mod}+Shift+1" = "move container to workspace number 1";
        "${mod}+Shift+2" = "move container to workspace number 2";
        "${mod}+Shift+3" = "move container to workspace number 3";
        "${mod}+Shift+4" = "move container to workspace number 4";
        "${mod}+Shift+5" = "move container to workspace number 5";
        "${mod}+Shift+6" = "move container to workspace number 6";
        "${mod}+Shift+7" = "move container to workspace number 7";
        "${mod}+Shift+8" = "move container to workspace number 8";
        "${mod}+Shift+9" = "move container to workspace number 9";
        # Note: workspaces can have any name you want, not just numbers.
        # We just use 1-10 as the default.

        #
        # Layout stuff:
        #

        # You can "split" the current object of your focus with
        # $mod+b or $mod+v, for horizontal and vertical splits
        # respectively.
        "${mod}+bar" = "splith";
        "${mod}+minus" = "splitv";

        # Switch the current container between different layout styles
        "${mod}+s" = "layout stacking";
        "${mod}+t" = "layout tabbed";
        "${mod}+e" = "layout toggle split";

        # Make the current focus fullscreen
        "F11" = "fullscreen";

        # Toggle the current focus between tiling and floating mode
        "${mod}+Shift+space" = "floating toggle";

        # Swap focus between the tiling area and the floating area
        "${mod}+space" = "focus mode_toggle";

        # Move focus to the parent container
        "${mod}+a" = "focus parent";

        #
        # Scratchpad:
        #

        # Sway has a "scratchpad", which is a bag of holding for windows.
        # You can send windows there and get them back later.

        # Move the currently focused window to the scratchpad
        "${mod}+Shift+0" = "move scratchpad";

        # Show the next scratchpad window or hide the focused scratchpad window.
        # If there are multiple scratchpad windows, this command cycles through them.
        "${mod}+0" = "scratchpad show";

        #
        # Resizing containers:
        #

        # Enter resize mode
        "${mod}+r" = "mode resize";
      };

      modes = {
        resize = {
          # left will shrink the containers width
          # right will grow the containers width
          # up will shrink the containers height
          # down will grow the containers height
          "${cfg.config.left}" = "resize shrink width 10 px";
          "${cfg.config.down}" = "resize grow height 10 px";
          "${cfg.config.up}" = "resize shrink height 10 px";
          "${cfg.config.right}" = "resize grow width 10 px";

          # Ditto, with arrow keys
          Left = "resize shrink width 10 px";
          Down = "resize grow height 10 px";
          Up = "resize shrink height 10 px";
          Right = "resize grow width 10 px";

          # Return to default mode
          Escape = "mode default";
          Return = "mode default";
        };
      };
    };

    extraSessionCommands = ''
      export XDG_CURRENT_DESKTOP=sway;
      export XDG_SESSION_DESKTOP=sway
      export SDL_VIDEODRIVER=wayland
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATOR=1;
      export _JAVA_AWT_WM_NONREPARENTING=1

      if [ ! -d $(xdg-user-dir PICTURES)/Screenshots ]; then
        mkdir $(xdg-user-dir PICTURES)/Screenshots
      fi;
    '';
  };

  home.packages = with pkgs; [
    wl-clipboard
    brightnessctl
    grim
    slurp
    libsForQt5.qt5.qtwayland
    qt6.qtwayland
  ];
}
