{ fetchFromGitHub
, stdenvNoCC
}:

let
  version = "117";

in
stdenvNoCC.mkDerivation rec {
  pname = "firefox-gnome-theme";
  version = "117";

  src = fetchFromGitHub {
    owner = "rafaelmardojai";
    repo = "firefox-gnome-theme";
    rev = "v${version}";
    sha256 = "sha256-ulG+9TcjI27RQF/5t7i+ED38gLuK5jbXNJHBxs4QBV0=";
  };

  installPhase = ''
    mkdir -p $out/chrome

    cp userChrome.css $out/chrome
    cp userContent.css $out/chrome
    cp -r theme $out/chrome
  '';
}
