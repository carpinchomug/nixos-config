{ pkgs, ... }:

{
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-gtk
      fcitx5-mozc
      libsForQt5.fcitx5-qt
    ];
  };

  programs.emacs.wrapperArguments = [
    "--set XMODIFIERS @im=none"
    "--set GTK_IM_MODULE xim"
  ];
}
