{ pkgs, kmonad, ... }:

let
  kmonad-static = kmonad.packages.${pkgs.system}.default;

in
{
  imports = [
    ./emacs
    ./foot
    ./helix
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
    libsForQt5.kdenlive
    kmonad-static
    networkmanagerapplet
    
    gnumake
    just
    pre-commit


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

    # Latex
    texlive.combined.scheme-full
    bibutils
    texlab

    # Lua
    sumneko-lua-language-server

    # Nix
    rnix-lsp

    # Python
    (python3.withPackages (ps: with ps; [
      numpy
      scipy
      matplotlib
      ipython
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

    fluent-icon-theme
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

  xdg.configFile."kmonad/config.kbd".source = ./kmonad/config.kbd;
}
