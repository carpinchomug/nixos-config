{ config, inputs, withSystem, ... }:

let
  inherit (inputs.home-manager.lib) homeManagerConfiguration;

  modules = import ./modules;

  home = { pkgs, lib, ... }: {
    imports = [
      ./config
      inputs.nix-colors.homeManagerModules.default
      inputs.nix-index-database.hmModules.nix-index
    ];

    home.username = "akiyoshi";
    home.homeDirectory = "/home/akiyoshi";

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

    # Update the state version as needed.
    # See the changelog here:
    # https://nix-community.github.io/home-manager/release-notes.html#sec-release-23.05
    home.stateVersion = "23.05";

    nix.extraOptions = ''
      # Enable nix commands and flakes.
      experimental-features = nix-command flakes
    '';

    nix.package = pkgs.nix;
    nix.settings.auto-optimise-store = true;
    nix.registry.nixpkgs.flake = inputs.nixpkgs;
    nix.registry.nixpkgs-stable.flake = inputs.nixpkgs-stable;

    home.sessionVariables.NIX_PATH = lib.concatStringsSep ":" [
      "nixpkgs=flake:nixpkgs"
      "nixpkgs-stable=flake:nixpkgs-stable"
    ] + "$\{NIX_PATH:+:$NIX_PATH}";

    nixpkgs.config.allowUnfree = true;
    nixpkgs.overlays = [
      config.flake.overlays.default
      inputs.nur.overlay
    ];
  };

in
{
  flake.homeConfigurations = {
    laptop = withSystem "x86_64-linux" ({ pkgs, ... }:
      homeManagerConfiguration {
        inherit pkgs;
        modules = [
          home
          modules.full
          ./profiles/laptop.nix
        ];
        extraSpecialArgs = { root = ./.; };
      }
    );

    wsl = withSystem "x86_64-linux" ({ pkgs, ... }:
      homeManagerConfiguration {
        inherit pkgs;
        modules = [
          home
          modules.minimal
          ./modules/editors/emacs
          ./modules/misc/fcitx5
          ./modules/misc/fonts
          ./profiles/wsl.nix
        ];
        extraSpecialArgs = { root = ./.; };
      }
    );
  };
}
