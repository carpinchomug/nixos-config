{ pkgs, kmonad, battery-notification, ... }:

{
  imports = [
    ./emacs
    ./foot
    ./helix
    ./kmonad
    ./zathura
    ./bash.nix
    ./chromium.nix
    ./firefox.nix
    ./git.nix
  ];

  home.packages = with pkgs; [
    ripgrep
    bat
    bottom
    zip
    unzip
    ffmpeg
    efibootmgr
    thefuck
    openconnect
    neofetch
    vlc
    gimp
    libreoffice
    inkscape
    blender
    freecad
    zotero
    pandoc
    kmonad
    battery-notification

    gnumake
    just
    pre-commit

    exercism


    # Bash
    nodePackages.bash-language-server

    # C/C++
    gcc

    # Haskell
    haskellPackages.ghc
    haskellPackages.cabal-install
    haskellPackages.haskell-language-server

    # HTML/CSS/JSON
    nodePackages.vscode-langservers-extracted

    # JavaScript & TypeScript
    nodejs
    nodePackages.typescript
    nodePackages.typescript-language-server

    # Julia
    julia-bin

    # Jupyter
    jupyter
    python3Packages.jupytext

    # Latex
    texlive.combined.scheme-full
    bibutils
    texlab
    lua54Packages.digestif

    # Lua
    lua54Packages.lua
    sumneko-lua-language-server

    # Nix
    rnix-lsp

    # Python
    (python3.withPackages (ps: with ps; [
      numpy
      scipy
      matplotlib
      ipython
      ipykernel
      python-lsp-server
      pyls-isort
    ]))

    # Rust
    rustc
    cargo
    cargo-edit
    clippy
    rustfmt
    rust-analyzer

    # Yaml
    nodePackages.yaml-language-server
  ];

  programs.exa = {
    enable = true;
    enableAliases = true;
  };

  programs.starship = {
    enable = true;
    settings.nix_shell.symbol = " ";
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  home.file.".latexmkrc".source = ./latexmkrc;
}
