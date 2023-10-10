{ config, ... }:

{
  programs.foot = {
    enable = true;

    settings = {
      main = {
        font = "Iosevka Nerd Font:size=13";
        dpi-aware = "no";
        pad = "5x5";
      };

      mouse.hide-when-typing = "yes";

      colors = {
        alpha = 1.0;
        background = "ffffff";
        foreground = "000000";

        regular0 = config.colorScheme.colors.base00;
        regular1 = config.colorScheme.colors.base01;
        regular2 = config.colorScheme.colors.base02;
        regular3 = config.colorScheme.colors.base03;
        regular4 = config.colorScheme.colors.base04;
        regular5 = config.colorScheme.colors.base05;
        regular6 = config.colorScheme.colors.base06;
        regular7 = config.colorScheme.colors.base07;

        bright0 = config.colorScheme.colors.base08;
        bright1 = config.colorScheme.colors.base09;
        bright2 = config.colorScheme.colors.base0A;
        bright3 = config.colorScheme.colors.base0B;
        bright4 = config.colorScheme.colors.base0C;
        bright5 = config.colorScheme.colors.base0D;
        bright6 = config.colorScheme.colors.base0E;
        bright7 = config.colorScheme.colors.base0F;
      };
    };
  };
}
