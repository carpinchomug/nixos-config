{
  perSystem = { config, inputs', ... }: {
    overlayAttrs = {
      inherit (config.packages) firefox-gnome-theme fcitx5-mozc reveal;

      ollama = inputs'.nixpkgs-ollama.legacyPackages.ollama;

      stable = inputs'.nixpkgs-stable.legacyPackages;
    };
  };
}
