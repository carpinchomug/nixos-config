{ config, lib, ... }:

{
  imports = [ ./gitignore.nix ];

  programs.git = {
    enable = true;
    extraConfig = {
      core.editor = "hx";
      init.defaultBranch = "main";
    };
  };
}
