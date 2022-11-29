{
  programs.bash = {
    enable = true;

    profileExtra = ''
      # export EDITOR=hx
      export PATH=/home/akiyoshi/.cargo/bin:$PATH

      # Start sway
      if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
        exec sway
      fi

      swaymsg exec sway
    '';

    bashrcExtra = ''
      eval $(thefuck --alias)
    '';
  };

  home.shellAliases = {
    quickpy = "nix flake init --template github:carpinchomug/flake-templates#quickpython";
  };
}
