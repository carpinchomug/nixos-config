{ pkgs, wayland, ... }:

{
  i18n.inputMethod = {
    enabled = if wayland then "fcitx5" else "ibus";
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
