{ config, lib, pkgs, root, wayland, ... }:

let
  emacsPackage = pkgs.emacsWithPackagesFromUsePackage {
    package = if wayland then pkgs.emacs29-pgtk else pkgs.emacs29;
    config = root + /config/emacs/config.org;
    alwaysEnsure = true;
    alwaysTangle = true;

    extraEmacsPackages = epkgs: with epkgs; [
      diminish
      treesit-grammars.with-all-grammars
      use-package

      (callPackage ./kbd-mode.nix { })
      (callPackage ./typst-ts-mode.nix { })
    ];

    override = self: super: {
      mozc = super.mozc.overrideAttrs {
        postPatch = ''
          substituteInPlace src/unix/emacs/mozc.el \
            --replace '"mozc_emacs_helper"' '"${pkgs.fcitx5-mozc}/bin/mozc_emacs_helper"'
        '';
      };
      ox-reveal = super.ox-reveal.overrideAttrs {
        postPatch = ''
          substituteInPlace ox-reveal.el \
            --replace '"./reveal.js"' '"file://${pkgs.reveal}/lib/node_modules/reveal.js"'
        '';
      };
    };
  };

in
{
  imports = [ (root + /modules/misc/fonts) ];

  programs.emacs = {
    enable = true;
    package = emacsPackage;
  };

  services.emacs = {
    enable = true;
    client = {
      enable = true;
      arguments = [ "-c" ];
    };
  };

  programs.bash.initExtra = ''
    [ -n "$EAT_SHELL_INTEGRATION_DIR" ] && \
      source "$EAT_SHELL_INTEGRATION_DIR/bash"
  '';

  programs.zsh.initExtra = ''
    [ -n "$EAT_SHELL_INTEGRATION_DIR" ] && \
      source "$EAT_SHELL_INTEGRATION_DIR/zsh"
  '';
}
