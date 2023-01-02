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
    package = pkgs.emacsPgtk; # gcc emacs pure gtk

    extraPackages = epkgs: with epkgs; [
      # languages
      julia-mode
      lua-mode
      nix-mode
      rustic
      auctex

      # lsp
      eglot
      eglot-jl

      yasnippet
      yasnippet-snippets

      # org-mode
      org

      evil

      # utilities
      corfu # completeion
      magit
      pdf-tools
      jupyter
      code-cells
      use-package
      which-key
      direnv

      vertico
      consult
      orderless
      marginalia
      embark
      embark-consult
      cape
      expand-region
    ];

    # extraConfig = ''
    #   ${builtins.readFile ./init.el}
    # '';
  };

  xdg.configFile = {
    "emacs/init.el".source = ./init.el;
    "emacs/eshell/alias".source = ./alias;
    "emacs/templates".source = ./templates;
  };
}
