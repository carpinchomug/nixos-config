{ pkgs, ... }:

{
  services = {
    gnome-keyring.enable = true;
    udiskie = {
      enable = true;
      automount = true;
      notify = true;
      tray = "never";
    };
  };

  home.packages = [
    pkgs.udiskie
  ];
}
