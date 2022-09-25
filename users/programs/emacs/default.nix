{ pkgs, ... }:

{
  programs.emacs = {
    enable = true;
    package = pkgs.emacsPgtkNativeComp; # gcc emacs pure gtk

    extraPackages = epkgs: with epkgs; [
      # languages
      julia-mode
      nix-mode
      rustic

      # lsp
      eglot

      # org-mode
      org

      # utilities
      corfu # completeion
      magit
      pdf-tools
      jupyter
      use-package
      which-key
      direnv

      vertico
      consult
      orderless
      marginalia
      embark
      embark-consult

      # ui
      doom-themes
      doom-modeline
    ];

    # extraConfig = ''
    #   ${builtins.readFile ./init.el}
    # '';
  };

  home.file = {
    ".config/emacs/init.el" = { source = ./init.el; };
    ".config/emacs/eshell/alias" = { source = ./alias; };
  };
}
