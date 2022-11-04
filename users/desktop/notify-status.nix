{ pkgs, ... }:

let
  acpi = "${pkgs.acpi}/bin/acpi";
  notify-send = "${pkgs.libnotify}/bin/notify-send";
  nmcli = "${pkgs.networkmanager}/bin/nmcli";

  notify-status = pkgs.writeShellScriptBin "notify-status" ''
    battery=$(${acpi} -b | cut -d : -f2 | cut -d , -f1,2 | sed 's/[A-Z]/\L&/g' | sed 's/^[[:space:]]*//')
    wifi=$(${nmcli} device status | grep 'wifi ' | awk '{print $4}')

    ${notify-send} Status "Date: $(date "+%A, %-d %B")
    Time: $(date "+%H:%M")
    Battery: $battery
    Wifi: $wifi"
  '';

in
{
  home.packages = [
    notify-status
  ];
}
