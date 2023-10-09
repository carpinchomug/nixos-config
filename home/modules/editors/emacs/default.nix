{ config, lib, pkgs, root, ... }:

let
  inherit (config.wayland.windowManager) hyprland sway;
  wayland = hyprland.enable || sway.enable;
  package = if wayland then pkgs.emacs29-pgtk else pkgs.emacs29;

in
{
  imports = [ (root + /modules/misc/fonts) ];

  programs.emacs = {
    inherit package;

    enable = true;

    extraPackages = epkgs: with epkgs; [
      ace-window
      auctex
      avy
      beacon
      cape
      cmake-mode
      consult
      corfu
      csv-mode
      dashboard
      diff-hl
      diminish
      eat
      eglot
      embark
      embark-consult
      envrc
      exec-path-from-shell
      expand-region
      helpful
      hydra
      ligature
      markdown-mode
      magit
      marginalia
      modus-themes
      mozc
      nerd-icons
      nix-mode
      nix-ts-mode
      olivetti
      orderless
      org
      org-appear
      org-modern
      ox-reveal
      pdf-tools
      rainbow-mode
      rust-mode
      spacious-padding
      tempel
      treesit-auto
      treesit-grammars.with-all-grammars
      typst-ts-mode
      undo-tree
      use-package-hydra
      vertico
      vertico-posframe
      web-mode
      which-key
      whitespace-cleanup-mode
      yuck-mode
    ];

    overrides = self: super: {
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
      typst-ts-mode = pkgs.callPackage ./typst-ts-mode.nix {
        inherit (pkgs) fetchFromSourcehut;
        inherit (super) trivialBuild;
      };
    };
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
