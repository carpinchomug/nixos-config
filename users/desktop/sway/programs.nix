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

    # audio stuff
    pulseaudio
    pavucontrol
    pamixer
  ];

  programs.mako = {
    enable = true;
    defaultTimeout = 10;
  };

  wayland.windowManager.sway.extraSessionCommands = ''
    if [[ ! -d ~/Pictures/Screenshots ]]; then
      mkdir -p ~/Pictures/Screenshots
    fi
  '';
}
