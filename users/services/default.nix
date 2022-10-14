{ config, pkgs, ... }:

{
  services = {
    gnome-keyring.enable = true;
    udiskie.enable = true;
  };
}
