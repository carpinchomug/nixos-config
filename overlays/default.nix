{
  perSystem = { config, inputs', ... }: {
    overlayAttrs = {
      inherit (config.packages) firefox-gnome-theme fcitx5-mozc reveal;

      stable = inputs'.nixpkgs-stable.legacyPackages;
    };
  };
}
