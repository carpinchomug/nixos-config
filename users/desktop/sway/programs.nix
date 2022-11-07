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

  wayland.windowManager.sway.extraSessionCommands = ''
    if [[ ! -d ~/Pictures/Screenshots ]]; then
      mkdir -p ~/Pictures/Screenshots
    fi
  '';

  programs.swaylock.settings = {
    image = "$HOME/.config/wallpapers/serenity.png";
  };
}
