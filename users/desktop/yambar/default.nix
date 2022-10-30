{ pkgs, ... }:

{
  home.packages = [ pkgs.yambar ];

  xdg.configFile."yambar/config.yml".source = ./config.yml;
}
