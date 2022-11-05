{ lib, pkgs, ... }:

let
  rose-pine-gtk3 = with pkgs; stdenv.mkDerivation
    rec {
      pname = "rose-pine-gtk3";
      version = "2.1.0";

      src = fetchFromGitHub {
        owner = "rose-pine";
        repo = "gtk";
        rev = "v${version}";
        sha256 = "sha256-MT8AeC+uGRZS4zFNvAqxqSLVYpd9h64RdSvr6Ky4HA4=";
      };

      nativeBuildInputs = [
        gtk3
      ];

      buildInputs = [
        gnome-themes-extra
      ];

      propagatedUserEnvPkgs = [
        gtk-engine-murrine
      ];

      installPhase = ''
        runHook preInstall
        mkdir -p $out/share/themes
        cp -r gtk3/rose-pine-gtk $out/share/themes
        cp -r gtk3/rose-pine-moon-gtk $out/share/themes
        cp -r gtk3/rose-pine-dawn-gtk $out/share/themes
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
      size = 11;
    };

    theme = {
      package = pkgs.adw-gtk3;
      name = "adw-gtk3";
    };

    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus";
    };
  };
}
