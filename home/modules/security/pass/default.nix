{ config, pkgs, ... }:

let
  inherit (config.wayland.windowManager) hyprland sway;
  wayland = hyprland.enable || sway.enable;
  package = (if wayland then pkgs.pass-wayland else pkgs.pass).override {
    # Remove this override after this PR is merged.
    # https://github.com/NixOS/nixpkgs/pull/245479
    gnupg = pkgs.stable.gnupg;
  };

in
{
  programs.password-store = {
    inherit package;
    enable = true;
  };
}
