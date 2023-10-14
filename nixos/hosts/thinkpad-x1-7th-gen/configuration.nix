{ inputs, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-7th-gen
  ];

  networking = {
    hostName = "thinkpad";
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
      unmanaged = [ "except:interface-name:wlp0s20f3" ];
      wifi.powersave = false;
    };
    wireless.enable = true;
  };

  systemd.network.networks = {
    "10-enp0s31f6" = {
      matchConfig.Name = "enp0s31f6";
      networkConfig.DHCP = "yes";
    };
  };

  hardware.opengl.extraPackages = [ pkgs.intel-compute-runtime ];

  services.fstrim.enable = true;
  services.fwupd.enable = true;
  services.openssh.enable = true;
  services.udisks2.enable = true;

  # https://techpatterns.com/forums/about2831.html
  boot.blacklistedKernelModules = [ "i2c_i801" ];
}
