{ config, lib, ... }:

{
  xdg.configFile = {
    emacs = {
      source = ./emacs;
      recursive = true;
    };
    nvim = {
      source = ./nvim;
      recursive = true;
    };
  };
}
