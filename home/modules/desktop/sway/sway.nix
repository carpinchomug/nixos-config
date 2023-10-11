{ config, lib, pkgs, ... }:

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
          bg = lib.mkDefault "${cfg.package}/share/backgrounds/sway/Sway_Wallpaper_Blue_1920x1080.png fill";
        };
      };

      seat = {
        "seat0" = {
          xcursor_theme = "${config.gtk.cursorTheme.name} ${builtins.toString config.gtk.cursorTheme.size}";
        };
      };

      gaps = {
        inner = 8;
      };

      window = {
        titlebar = false;
        border = 2;
      };

      floating = {
        border = 2;
      };

      fonts = {
        names = [
          "Sarasa Mono J"
          "Iosevka Nerd Font"
          "Noto Sans CJK JP"
          "DejaVu Sans Mono"
        ];

        size = 11.0;
      };

      startup = [
        {
          command = "${configure-gtk}/bin/configure-gtk";
          always = true;
        }
      ];

      keybindings = import ../keybindings.nix {
        inherit cfg config lib pkgs;
        wayland = true;
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
