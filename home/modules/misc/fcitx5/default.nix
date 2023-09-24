{ config, lib, pkgs, ... }:

{
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-gtk
      fcitx5-mozc
      libsForQt5.fcitx5-qt
    ];
  };

  home.shellAliases = {
    emacs = lib.mkIf
      config.programs.emacs.enable
      "XMODIFIERS=@im=none GTK_IM_MODULE=xim emacs";
  };

  programs.emacs.wrapperArguments = [
    "--set XMODIFIERS @im=none"
    "--set GTK_IM_MODULE xim"
  ];
}
