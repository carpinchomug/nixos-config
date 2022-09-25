{ config, pkgs, ... }:

{
  imports = [ ./fcitx5.nix ];

  services.gnome-keyring.enable = true;

  # enable udisks2 system-wide for this
  services.udiskie.enable = true;

  # Note, for the applet to work, the 'blueman' service should be enabled system-wide.
  services.blueman-applet.enable = true;

  services.network-manager-applet.enable = true;
}
