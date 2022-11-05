let
  themes = import ./themes.nix;

in
{
  programs.foot = {
    enable = true;

    settings = {
      main = {
        font = "FiraCode Nerd Font:size=13";
        dpi-aware = "no";
      };

      # revert to default:
      #   color: inversed foreground and background
      #   blink: no
      # cursor = {
      #   color = "e0def4 555169";
      #   blink = "Yes";
      # };

      cursor = {
        color = "fdf6e3 586e75";
      };

      mouse = {
        hide-when-typing = "yes";
      };

      colors = themes.rose-pine-dawn // { alpha = 1.0; };
    };
  };
}
