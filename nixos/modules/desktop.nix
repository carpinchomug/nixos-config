{ pkgs, ... }:

{
  hardware.opengl.enable = true;

  fonts = {
    enableDefaultFonts = true;

    fonts = with pkgs; [
      noto-fonts
      noto-fonts-cjk-serif
      noto-fonts-cjk-sans
      noto-fonts-emoji
      iosevka
      sarasa-gothic
    ];

    fontconfig = {
      defaultFonts = {
        sansSerif = [
          "Noto Sans"
          "Noto Sans CJK JP"
        ];
        serif = [
          "Noto Serif"
          "Noto Serif CJK JP"
        ];
        monospace = [
          "Iosevka"
          "Sarasa Mono J"
        ];
        emoji = [
          "Noto Color Emoji"
        ];
      };
    };
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # https://nix-community.github.io/home-manager/index.html#_why_do_i_get_an_error_message_about_literal_ca_desrt_dconf_literal_or_literal_dconf_service_literal
  programs.dconf.enable = true;

  services.dbus.packages = [ pkgs.gcr ];
}
