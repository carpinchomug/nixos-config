{
  programs.helix.enable = true;

  imports = [
    ./config.nix
    ./languages.nix
    ./themes.nix
  ];
}
