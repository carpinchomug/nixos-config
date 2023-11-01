{ config, lib, pkgs, root, ... }:

{
  xdg.configFile = {
    emacs = lib.mkIf config.programs.emacs.enable {
      source = ./emacs;
      recursive = true;
    };

    helix = lib.mkIf config.programs.helix.enable {
      source = ./helix;
      recursive = true;
    };

    nvim = lib.mkIf config.programs.neovim.enable {
      source = ./nvim;
      recursive = true;
    };
  };
}
