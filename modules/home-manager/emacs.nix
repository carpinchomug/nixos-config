{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.programs.emacs;

  # Copied from all-packages.nix, with modifications to support
  # overrides.
  emacsPackages =
    let epkgs = pkgs.emacsPackagesFor cfg.package;
    in epkgs.overrideScope' cfg.overrides;

  emacsWithPackages = emacsPackages.emacsWithPackages cfg.extraPackages;

  emacsWrapped =
    if cfg.wrapperArguments == [ ]
    then emacsWithPackages
    else
      pkgs.symlinkJoin {
        name = "emacs";
        paths = [ emacsWithPackages ];
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

      extraPackages = mkOption {
        default = self: [ ];
        type = hm.types.selectorFunction;
        defaultText = "epkgs: []";
        example = literalExpression "epkgs: [ epkgs.emms epkgs.magit ]";
        description = ''
          Extra packages available to Emacs. To get a list of
          available packages run:
          {command}`nix-env -f '<nixpkgs>' -qaP -A emacsPackages`.
        '';
      };

      overrides = mkOption {
        default = self: super: { };
        type = hm.types.overlayFunction;
        defaultText = "self: super: {}";
        example = literalExpression ''
          self: super: rec {
            haskell-mode = self.melpaPackages.haskell-mode;
            # ...
          };
        '';
        description = ''
          Allows overriding packages within the Emacs package set.
        '';
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
