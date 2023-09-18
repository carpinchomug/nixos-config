{ root, ... }:

{
  imports = [
    ./flameshot.nix
    ./foot.nix
    ./mako.nix
    ./sway.nix
    ./swayidle.nix
    ./swaylock.nix
    ./wofi.nix
  ];
}
