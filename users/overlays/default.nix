{ pkgs, emacs-overlay, battery-notification, ... }:

{
  nixpkgs.overlays = [
    emacs-overlay.overlay

    (self: super: {
      battery-notification = battery-notification.packages.${super.system}.default;
    })
  ];
}
