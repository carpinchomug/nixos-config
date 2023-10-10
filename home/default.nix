{ config, inputs, withSystem, ... }:

let
  inherit (inputs.home-manager.lib) homeManagerConfiguration;

  modules = import ./modules;

  home = { pkgs, lib, ... }: {
    imports = [
      ./config
      config.flake.homeManagerModules.emacs
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

    home.shellAliases.hm = "home-manager";

    nix.extraOptions = ''
      # Enable nix commands and flakes.
      experimental-features = nix-command flakes
    '';

    nix.package = pkgs.nix;
    nix.settings.auto-optimise-store = true;
    nix.settings.substituters = [
      "https://cache.nixos.org/"
      "https://nix-community.cachix.org"
    ];
    nix.settings.trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
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
    "akiyoshi@thinkpad" = withSystem "x86_64-linux" ({ pkgs, ... }:
      homeManagerConfiguration {
        inherit pkgs;
        modules = [
          home
          modules.full
          ./profiles/main.nix
        ];
        extraSpecialArgs = { root = ./.; wayland = true; };
      }
    );

    "akiyoshi@wsl" = withSystem "x86_64-linux" ({ pkgs, ... }:
      homeManagerConfiguration {
        inherit pkgs;
        modules = [
          home
          modules.minimal
          ./desktop
          ./modules/browsers/firefox
          ./modules/editors/emacs
          ./modules/misc/fcitx5
          ./modules/misc/fonts
          ./misc/colorschemes
          ./misc/fcitx5
          ./misc/fonts
          ./misc/gtk
          ./misc/qt
          ./security/browserpass
          ./modules/wsl
          ./profiles/work.nix
        ];
        extraSpecialArgs = { root = ./.; wayland = false; };
      }
    );
  };
}
