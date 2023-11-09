let
  minimal = { pkgs, ... }: {
    imports = [
      ./editors/helix
      ./editors/neovim
      ./misc/git
      ./misc/starship
      ./misc/xdg
      ./security/gpg
      ./security/pass
      ./security/ssh
    ];

    home.packages = with pkgs; [
      bat
      bottom
      cabal-install
      conda
      exercism
      fd
      ffmpeg
      gdb
      ghc
      hunspell
      hunspellDicts.en-us
      hunspellDicts.en-gb-ise
      just
      nixd
      nixpkgs-fmt
      ripgrep
      texlab
      texlive.combined.scheme-full
      typst
      typst-lsp
      unzip
      xdg-user-dirs
      zip
    ];

    home.shellAliases = {
      hm = "home-manager";
      cd = "z";
    };

    programs.bash.enable = true;

    programs.direnv.enable = true;
    programs.direnv.nix-direnv.enable = true;

    programs.eza.enable = true;
    programs.eza.enableAliases = true;

    programs.info.enable = true;

    programs.nix-index.enable = true;
    programs.nix-index-database.comma.enable = true;

    programs.zoxide.enable = true;

    services.gnome-keyring.enable = true;

    services.ollama.enable = true;
  };

in
{
  inherit minimal;

  full = { pkgs, ... }: {
    imports = [
      minimal
      ./desktop
      ./browsers/chromium
      ./browsers/firefox
      ./editors/emacs
      ./misc/colorschemes
      ./misc/fcitx5
      ./misc/fonts
      ./misc/gtk
      ./misc/qt
      ./security/browserpass
    ];

    home.packages = with pkgs; [
      # GUI apps
      calibre
      inkscape
      zotero
    ];
  };
}
