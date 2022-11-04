{
  imports = [
    ./sway
    ./yambar
    ./fcitx5.nix
    ./fonts.nix
    ./gtk.nix
    ./i3status-rust.nix
    ./notify-status.nix
  ];

  xdg.configFile."wallpapers" = {
    recursive = true;
    source = ./wallpapers;
  };
}
