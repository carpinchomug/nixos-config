{
  perSystem = { config, inputs', ... }: {
    overlayAttrs = {
      inherit (config.packages) firefox-gnome-theme fcitx5-mozc;

      stable = inputs'.nixpkgs-stable.legacyPackages;
    };
  };
}
