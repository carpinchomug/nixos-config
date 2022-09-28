{ pkgs, emacs-overlay, ... }:

{
  # Update the state version as needed.
  # See the changelog here:
  # https://nix-community.github.io/home-manager/release-notes.html#sec-release-21.05
  home = {
    stateVersion = "21.11";
    username = "akiyoshi";
    homeDirectory = "/home/akiyoshi";
  };

  nixpkgs = {
    config = {
      allowUnfree = true;

      # permittedInsecurePackages = [
      #   "python3.10-mistune-0.8.4"
      # ];
    };

    overlays = [ emacs-overlay.overlay ];
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  
  xdg.enable = true;

  imports = [
    ./desktop
    ./programs
    ./services
  ];
}
