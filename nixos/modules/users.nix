{ pkgs, ... }:

{
  users.users.akiyoshi = {
    isNormalUser = true;
    extraGroups = [
      "libvirtd"
      "input"
      "networkmanager"
      "pipewire"
      "uinput"
      "wheel"
    ];
    packages = [ pkgs.helix ];
  };
}
