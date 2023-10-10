{ config, lib, pkgs, ... }:

let
  inherit (config.wayland.windowManager) sway;
  cfg = xsession.windowManager.i3;

in
{
  xsession.windowManager.i3 {
  enable = true;

  config = {
    inherit (sway)
      assigns
      bars
      colors
      defaultWorkspace
      floating
      focus
      fonts
      gaps
      keycodebindings
      # menu
      modifier
      # startup
      # terminal
      window
      workspaceAutoBackAndForth
      workspaceLayout
      workspaceOutputAssign;

    keybindings = import ../keybindings.nix {
      inherit cfg config lib pkgs;
      wayland = false;
    };

    startup = [
      {
        command = "${pkgs.feh}/bin/feh --bg-scale ${cfg.package}/share/backgrounds/sway/Sway_Wallpaper_Blue_1920x1080.png";
        always = true;
      }
    ];
  };
}
