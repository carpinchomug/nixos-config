{ config, lib, pkgs, ... }:

let
  inherit (lib) types;
  cfg = config.services.ollama;

in
{
  options = {
    services.ollama = {
      enable = lib.mkEnableOption "Ollama";

      package = lib.mkOption {
        type = types.package;
        default = pkgs.ollama;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];

    systemd.user.services.ollama = {
      Unit = {
        Description = "Ollama Service";
        After = [ "network-online.target" ];
      };

      Service = {
        ExecStart = "${cfg.package}/bin/ollama serve";
        Restart = "always";
        RestartSec = 3;
      };

      Install.WantedBy = [ "default.target" ];
    };
  };
}