{ pkgs, ... }:

{
  services.emacs = {
    enable = true;
    defaultEditor = true;
    client = {
      enable = true;
      arguments = [
        "-c"
      ];
    };
  };

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

      auctex

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
    ];

    # extraConfig = ''
    #   ${builtins.readFile ./init.el}
    # '';
  };

  xdg.configFile = {
    "emacs/init.el".source = ./init.el;
    "emacs/eshell/alias".source = ./alias;
  };
}
