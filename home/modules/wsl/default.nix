{ config, lib, pkgs, ... }:

{
  programs.bash.initExtra = ''
    export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0
  '';

  services.gpg-agent = {
    pinentryFlavor = null;
    extraConfig = ''
      pinentry-program "/mnt/c/Program Files (x86)/GnuPG/bin/pinentry-basic.exe"
    '';
  };

  xsession.profileExtra = ''
    xset -r 49
  '';
}
