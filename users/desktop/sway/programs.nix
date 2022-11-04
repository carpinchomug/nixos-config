{ pkgs, ... }:

{
  home.packages = with pkgs; [
    brightnessctl
    grim
    imv
    slurp
    swaylock
    swayidle
    wofi
    wl-clipboard
    wlogout
    swaybg
    swayr

    # audio stuff
    pulseaudio
    pavucontrol
    pamixer
  ];

  programs.mako = {
    enable = true;
    defaultTimeout = 20000; # specified in milliseconds
    height = 150;
  };

  wayland.windowManager.sway.extraSessionCommands = ''
    if [[ ! -d ~/Pictures/Screenshots ]]; then
      mkdir -p ~/Pictures/Screenshots
    fi
  '';
}
