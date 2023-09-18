{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      nvim-lspconfig
      zenbones-nvim
    ];
  };
}
