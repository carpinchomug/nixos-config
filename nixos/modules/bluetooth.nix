{
  hardware.bluetooth = {
    enable = true;
    settings = {
      General = {
        AutoEnable = false;
      };
    };
  };

  services.blueman.enable = true;
}
