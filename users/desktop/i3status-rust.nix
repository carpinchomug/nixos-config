{
  programs.i3status-rust = {
    enable = true;

    bars.default = {
      icons = "material-nf";
      blocks = [
        {
          block = "sound";
          on_click = "pavucontrol";
        }
        {
          block = "networkmanager";
          on_click = "nm-connection-editor";
          ap_format = "{strength} {ssid}";
          device_format = "{icon}{ap}";
          connection_format = "{devices}";
        }
        {
          block = "battery";
          format = "{percentage}";
        }
        {
          block = "time";
          format = "%a %d/%m %R";
        }
      ];
    };
  };
}
