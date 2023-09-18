{ inputs, ... }:

{
  perSystem = { pkgs, ... }: {
    packages = {
      fcitx5-mozc = pkgs.callPackage ./fcitx5-mozc.nix { };
      firefox-gnome-theme = pkgs.callPackage ./firefox-gnome-theme.nix { };
    };
  };
}
