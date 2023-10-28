{
  flake.homeManagerModules = {
    emacs = import ./emacs.nix;
    ollama = import ./ollama.nix;
  };
}
