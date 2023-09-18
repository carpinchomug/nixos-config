{ config, lib, pkgs, root, ... }:

let
  inherit (config.wayland.windowManager) hyprland sway;
  wayland = hyprland.enable || sway.enable;

  basePackage = if wayland then pkgs.emacs29-pgtk else pkgs.emacs29;

  emacsWithPackages = pkgs.emacsWithPackagesFromUsePackage {
    package = basePackage;

    config = root + /config/emacs/init.el;

    extraEmacsPackages = epkgs: with epkgs; [
      use-package
      diminish
      treesit-grammars.with-all-grammars
      # (pkgs.callPackage ./vc-use-package.nix {
      #   inherit (epkgs) trivialBuild;
      # })
    ];

    override = self: super: {
      mozc = super.mozc.overrideAttrs {
        postPatch = ''
          substituteInPlace src/unix/emacs/mozc.el \
            --replace '"mozc_emacs_helper"' '"${pkgs.fcitx5-mozc}/bin/mozc_emacs_helper"'
        '';
      };
    };
  };

  finalPackage = pkgs.symlinkJoin {
    name = "emacs";
    paths = [ emacsWithPackages ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/emacs \
        --set XMODIFIERS @im=none \
        --set GTK_IM_MODULE xim
    '';
  };

in
{
  imports = [ (root + /modules/misc/fonts) ];

  home.packages = [ finalPackage ];

  services.emacs = {
    enable = true;
    package = finalPackage;
    client = {
      enable = true;
      arguments = [ "-c" ];
    };
  };

  # xdg.configFile."emacs/init.el".source = cfg.config;

  programs.bash.initExtra = ''
    [ -n "$EAT_SHELL_INTEGRATION_DIR" ] && \
      source "$EAT_SHELL_INTEGRATION_DIR/bash"
  '';

  programs.zsh.initExtra = ''
    [ -n "$EAT_SHELL_INTEGRATION_DIR" ] && \
      source "$EAT_SHELL_INTEGRATION_DIR/zsh"
  '';
}

