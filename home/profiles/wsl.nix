{ lib, pkgs, ... }:

{
  programs.git = {
    userName = "Akiyoshi Suda";
  };

  programs.helix.defaultEditor = true;

  programs.ssh.enable = lib.mkForce false;

  services.gpg-agent.pinentryFlavor = null;
  services.gpg-agent.extraConfig = ''
    pinentry-program "/mnt/c/Program Files (x86)/GnuPG/bin/pinentry-basic.exe"
  '';
}
