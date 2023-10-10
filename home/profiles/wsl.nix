{ config, lib, pkgs, ... }:

{
  programs.bash.profileExtra = ''
    ${config.programs.gpg.package}/bin/gpg2 --export-ssh-key 0x00C5B82A696B63FB > ~/.ssh/gpg_personal.pub
    ${config.programs.gpg.package}/bin/gpg2 --export-ssh-key 0x3877C2BB0DF20510 > ~/.ssh/gpg_work.pub
  '';

  programs.git = {
    userName = "Akiyoshi Suda";
    signing = {
      key = "F047 C4CF 9EB3 CF7C 9976  DE56 3247 178A 7D4B AD28";
      signByDefault = true;
    };
  };

  programs.helix.defaultEditor = true;

  programs.ssh = {
    matchBlocks = {
      "github-personal" = {
        host = "github-personal";
        hostname = "github.com";
        identityFile = "~/.ssh/gpg_personal.pub";
      };
      "github-work" = {
        host = "github-work";
        hostname = "github.com";
        identityFile = "~/.ssh/gpg_work.pub";
      };
    };
  };

  services.gpg-agent.pinentryFlavor = null;
  services.gpg-agent.sshKeys = [
    "DC8A1E5C2A819D382B8E1A05B1EAB2680E36E88D"
    "5F15D9F76EAC16C2171BF73CB3D9F3548BC37A38"
  ];
  services.gpg-agent.extraConfig = ''
    pinentry-program "/mnt/c/Program Files (x86)/GnuPG/bin/pinentry-basic.exe"
  '';
}
