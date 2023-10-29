{ config, lib, pkgs, root, ... }:

{
  xdg.configFile = {
    emacs = lib.mkIf config.programs.emacs.enable {
      source = ./emacs;
      recursive = true;
      onChange = ''
        ${config.programs.emacs.finalPackage}/bin/emacs -Q --batch \
          --eval "(require 'ob-tangle)" \
          --eval '(org-babel-tangle-file "${root}/config/emacs/config.org")'
      '';
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
