{ config, lib, ... }:

let
  inherit (config.programs) chromium firefox;

in
{
  programs.browserpass = {
    enable = true;
    browsers =
      lib.optionals chromium.enable [ "chromium" ]
      ++ lib.optionals firefox.enable [ "firefox" ];
  };
}
