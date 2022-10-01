{ lib, pkgs, ... }:

let
  adw-gtk3 = pkgs.stdenv.mkDerivation rec {
    pname = "adw-gtk3";
    version = "v3.6";

    src = pkgs.fetchFromGitHub {
      owner = "lassekongo83";
      repo = "adw-gtk3";
      rev = "d52e24afcc182fe20d55c1270b8cbb1e3b77ffa6";
      sha256 = "sha256-8SD3qnjtIAM40JLo7XZAri3QAA4ot8X1XUtdko1Iml4=";
    };

    nativeBuildInputs = with pkgs; [
      # gtk3
      ninja
      meson
      sassc
      # gnome.gnome-themes-extra # adwaita engine for Gtk2
    ];
  };

  # rose-pine-gtk-latest = pkgs.stdenv.mkDerivation rec {
  #   pname = "rose-pine-gtk-latest";
  #   version = "v2.0.0";
  #
  #   src = pkgs.fetchFromGitHub {
  #     owner = "rose-pine";
  #     repo = "gtk";
  #     rev = "3b6b683e4f501a727e4d45643fc1d0f23a473bb9";
  #     sha256 = "sha256-nFEIom6akj85pWP7JP13+uWEZ/h5mKbEmmCoHu0RuLo=";
  #   };
  #
  #   buildInputs = with pkgs; [
  #     gtk3
  #     gnome.gnome-themes-extra # adwaita engine for Gtk2
  #   ];
  #
  #   propagatedUserEnvPkgs = with pkgs; [
  #     gtk-engine-murrine # murrine engine for Gtk2
  #   ];
  #
  #   installPhase = ''
  #     runHook preInstall
  #     mkdir -p $out/share/themes
  #     cp -a rose-pine-dawn-gtk $out/share/themes
  #     cp -a rose-pine-gtk $out/share/themes
  #     cp -a rose-pine-moon-gtk $out/share/themes
  #     runHook postInstall
  #   '';
  # };

  fluent-theme = pkgs.stdenv.mkDerivation rec {
    pname = "fluent-gtk-theme";
    version = "2022-06-15";
 
    src = pkgs.fetchFromGitHub {
      owner = "vinceliuice";
      repo = "Fluent-gtk-theme";
      rev = "94f164cd2ee6b573bd03e1a7b03c2e0645780208";
      sha256 = "sha256-7qTfg9N/41q0/7zUl0zNKCayFh2opIsiPJmB3z5N02Y=";
    };
 
    buildInputs = with pkgs; [
      gtk3
      gnome.gnome-themes-extra # adwaita engine for Gtk2
      sassc
    ];
 
    propagatedUserEnvPkgs = with pkgs; [
      gtk-engine-murrine # murrine engine for Gtk2
    ];
 
    postPatch = ''
      patchShebangs install.sh
    '';
 
    installPhase = ''
      runHook preInstall
      mkdir -p $out/share/themes
      unset name && ./install.sh -d $out/share/themes
      runHook postInstall
    '';
  };

in
{
  gtk = {
    enable = true;

    font = {
      package = pkgs.noto-fonts;
      name = "Noto Sans";
      size = 10;
    };

    iconTheme = {
      package = pkgs.fluent-icon-theme;
      name = "Fluent";
    };

    theme = {
      package = fluent-theme;
      name = "Fluent";
    };

    # gtk3.extraConfig = {
    #   gtk-application-prefer-dark-theme = true;
    # };

    # gtk4.extraConfig = {
    #   gtk-application-prefer-dark-theme = true;
    # };
  };
}
