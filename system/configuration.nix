{ pkgs, nixos-hardware, ... }:

{
  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      # enable flakes
      experimental-features = nix-command flakes
      # protect nix-shell against garbage collection
      keep-outputs = true
      keep-derivations = true
    '';
  };

  imports = [
    ./hardware-configuration.nix
    nixos-hardware.nixosModules.lenovo-thinkpad-x1-7th-gen
  ];

  time.timeZone = "Asia/Tokyo";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Create the uinput group for kmonad
  users.groups.uinput = { };

  users.users.akiyoshi = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "docker"
      "networkmanager"
      "input"
      "uinput"
    ];
  };
  services.udev.extraRules = ''
    # KMonad user access to /dev/uinput
    KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"
  '';

  networking = {
    hostName = "ThinkPad"; # Define your hostname.

    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;
    interfaces.enp0s31f6.useDHCP = true;
    interfaces.wlp0s20f3.useDHCP = true;

    networkmanager.enable = true;
  };

  sound.enable = true;

  # rtkit is optional but recommended
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    # media-session.enable = true;
  };

  hardware.bluetooth = {
    enable = true;
    settings = {
      General = {
        AutoEnable = false;
      };
    };
  };

  services.blueman.enable = true;

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-compute-runtime
    ];
  };

  # screen sharing
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
  };

  fonts = {
    enableDefaultFonts = true;

    fonts = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      noto-fonts-extra
    ];

    fontconfig = {
      defaultFonts = {
        serif = [ "Noto Serif" "Noto Serif CJK JP" ];
        sansSerif = [ "Noto Sans" "Noto Sans CJK JP" ];
        monospace = [ "Noto Sans Mono" "Noto Sans Mono CJK JP" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };

  environment.systemPackages = with pkgs; [
    wget
    vim
    firefox
  ];

  # Misc.
  services = {
    fstrim.enable = true;
    fwupd.enable = true;
    openssh.enable = true;
    udisks2.enable = true;

    # interception-tools =
    #   let
    #     intercept = "${pkgs.interception-tools}/bin/intercept";
    #     caps2esc = "${pkgs.interception-tools-plugins.caps2esc}/bin/caps2esc";
    #     uinput = "${pkgs.interception-tools}/bin/uinput";
    #   in
    #   {
    #     enable = true;

    #     # https://discourse.nixos.org/t/troubleshooting-help-services-interception-tools/20389
    #     udevmonConfig = ''
    #       - JOB: ${intercept} -g $DEVNODE | ${caps2esc} | ${uinput} -d $DEVNODE
    #         DEVICE:
    #           EVENTS:
    #             EV_KEY: [KEY_CAPSLOCK, KEY_ESC]
    #     '';
    #   };
  };

  virtualisation.docker.enable = true;

  # https://techpatterns.com/forums/about2831.html
  boot.blacklistedKernelModules = [ "i2c_i801" ];


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?}
}
