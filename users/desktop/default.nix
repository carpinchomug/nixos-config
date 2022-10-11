{
  imports = [
    ./sway
    ./fcitx5.nix
    ./fonts.nix
    ./gtk.nix
    ./i3status-rust.nix
  ];

  xdg.configFile."wallpapers" = {
    recursive = true;
    source = ./wallpapers;
  };
}
