{ pkgs, ... }:

{
  home.packages = with pkgs; [
    brightnessctl
    grim
    imv
    mako
    slurp
    swaylock
    swayidle
    wofi
    wl-clipboard
    wlogout

    # audio stuff
    pulseaudio
    pavucontrol
    pamixer
  ];

  wayland.windowManager.sway.extraSessionCommands = ''
    if [[ ! -d ~/Pictures/Screenshots ]]; then
      mkdir -p ~/Pictures/Screenshots
    fi
  '';
}
