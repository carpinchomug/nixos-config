{ inputs, ... }:

let
  inherit (inputs.nixpkgs.lib) nixosSystem;

  defaultModule = { pkgs, ... }: {
    nix.settings.auto-optimise-store = true;
    nix.settings.trusted-users = [ "root" "@wheel" ];
    #https://github.com/NixOS/nix/pull/7423
    nix.nixPath = [
      "nixpkgs=flake:nixpkgs"
      "nixpkgs-stable=flake:nixpkgs-stable"
    ];
    nix.registry.nixpkgs.flake = inputs.nixpkgs;
    nix.registry.nixpkgs-stable.flake = inputs.nixpkgs-stable;
    nix.extraOptions = ''
      # enable nix commands and flakes
      experimental-features = nix-command flakes
    '';

    environment.systemPackages = [
      pkgs.vim
      pkgs.wget
    ];

    time.timeZone = "Asia/Tokyo";

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "23.05"; # Did you read the comment?
  };

in
{
  flake.nixosConfigurations = {
    thinkpad = nixosSystem {
      modules = [
        defaultModule
        ./hosts/thinkpad-x1-7th-gen/configuration.nix

        ./modules/bluetooth.nix
        ./modules/boot.nix
        ./modules/desktop.nix
        ./modules/i18n.nix
        ./modules/kanata.nix
        ./modules/networking.nix
        ./modules/pipewire.nix
        ./modules/polkit.nix
        ./modules/users.nix
        ./modules/virtualisation.nix
      ];
      specialArgs = { inherit inputs; };
    };
  };
}
