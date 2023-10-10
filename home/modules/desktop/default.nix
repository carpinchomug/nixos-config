{ wayland, ... }:

{
  imports = [
    (if wayland then ./sway else ./i3)
    ./flameshot.nix
  ];
}
