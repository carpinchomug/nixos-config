{ config, lib, pkgs, wayland, ... }:

{
  imports = [
    (if wayland then ./sway else ./i3)
    ./flameshot.nix
  ];

  wayland.windowManager.sway.config =
    lib.mapAttrs (n: lib.mkDefault) (import ./options.nix {
      inherit config lib pkgs wayland;
    });

  xsession.windowManager.i3.config =
    lib.mapAttrs (n: lib.mkDefault) (import ./options.nix {
      inherit config lib pkgs wayland;
    });
}
