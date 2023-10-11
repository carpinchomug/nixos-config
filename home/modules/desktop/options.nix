{ config, lib, pkgs, wayland }:

let
  left = "h";
  down = "j";
  up = "k";
  right = "l";

in
{
  # Common options

  # assigns

  # bars

  # colors

  # defaultWorkspace

  floating = {
    border = 2;
  };

  # focus

  fonts = {
    names = [
      "Sarasa Mono J"
      "Iosevka Nerd Font"
      "Noto Sans CJK JP"
      "DejaVu Sans Mono"
    ];

    size = 11.0;
  };

  gaps = {
    inner = 8;
  };

  # keycodebindings

  # DO NOT DECLARE HERE
  # menu

  modes = {
    resize = {
      # left will shrink the containers width
      # right will grow the containers width
      # up will shrink the containers height
      # down will grow the containers height
      "${left}" = "resize shrink width 10 px";
      "${down}" = "resize grow height 10 px";
      "${up}" = "resize shrink height 10 px";
      "${right}" = "resize grow width 10 px";

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

  modifier = "Mod4";

  # DO NOT DECLARE HERE
  # startup

  # DO NOT DECLARE HERE
  # terminal

  window = {
    titlebar = false;
    border = 2;
  };

  # workspaceAutoBackAndForth
  
  # workspaceLayout
  
  # workspaceOutputAssign;
}
