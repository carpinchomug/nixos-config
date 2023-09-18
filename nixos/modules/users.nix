{ pkgs, ... }:

{
  users.users.akiyoshi = {
    isNormalUser = true;
    extraGroups = [
      "libvirtd"
      "networkmanager"
      "pipewire"
      "wheel"
    ];
    packages = [ pkgs.helix ];
  };
}
