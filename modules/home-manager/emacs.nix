{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.programs.emacs;

  emacsWrapped =
    if cfg.wrapperArguments == [ ]
    then cfg.package
    else
      pkgs.symlinkJoin {
        name = "emacs";
        paths = [ cfg.package ];
        buildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/emacs ${lib.concatStringsSep " " cfg.wrapperArguments}
        '';
      };

in
{
  disabledModules = [ "programs/emacs.nix" ];

  options = {
    programs.emacs = {
      enable = mkEnableOption "Emacs";

      package = mkOption {
        type = types.package;
        default = pkgs.emacs;
        defaultText = literalExpression "pkgs.emacs";
        example = literalExpression "pkgs.emacs25-nox";
        description = "The Emacs package to use.";
      };

      wrapperArguments = mkOption {
        default = [ ];
        type = types.listOf types.str;
      };

      finalPackage = mkOption {
        type = types.package;
        visible = false;
        readOnly = true;
        description = ''
          The Emacs package including any overrides and extra packages.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.finalPackage ];
    programs.emacs.finalPackage = emacsWrapped;
  };
}
