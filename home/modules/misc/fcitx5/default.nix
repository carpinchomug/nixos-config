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
    emacsclient = lib.mkIf
      config.services.emacs.enable
      "XMODIFIERS=@im=none GTK_IM_MODULE=xim emacsclient";
  };
}
