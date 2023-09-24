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

    programs.bash.enable = true;

    programs.direnv.enable = true;
    programs.direnv.nix-direnv.enable = true;

    programs.eza.enable = true;
    programs.eza.enableAliases = true;

    programs.info.enable = true;

    programs.nix-index.enable = true;
    programs.nix-index-database.comma.enable = true;

    services.gnome-keyring.enable = true;

    home.packages = with pkgs; [
      bat
      bottom
      conda
      fd
      ffmpeg
      gdb
      just
      nixd
      nixpkgs-fmt
      ripgrep
      texlab
      texlive.combined.scheme-full
      unzip
      xdg-user-dirs
      zip
    ];
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
      inkscape
    ];
  };
}
