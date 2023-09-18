{ pkgs, ... }:

{
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    iosevka
    (iosevka-bin.override { variant = "aile"; })
    sarasa-gothic
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-emoji
    (nerdfonts.override {
      fonts = [
        "Iosevka"
        "CascadiaCode"
      ];
    })
  ];
}
