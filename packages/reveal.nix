{ lib
, buildNpmPackage
, fetchFromGitHub
}:

let
  version = "4.6.0";

in
buildNpmPackage {
  inherit version;
  pname = "reveal";

  src = fetchFromGitHub {
    owner = "hakimel";
    repo = "reveal.js";
    rev = version;
    hash = "sha256-a+J+GasFmRvu5cJ1GLXscoJ+owzFXsLhCbeDbYChkyQ=";
  };

  npmDepsHash = "sha256-SZzcL47DoSRaUfdE/OctrRMqFr79NT6TtdYI1kwWQEM=";

  env = {
    PUPPETEER_SKIP_CHROMIUM_DOWNLOAD = true;
  };

  checkPhase = ''
    runHook preCheck

    npm run test

    runHook postCheck
  '';

  meta = {
    license = lib.licenses.mit;
  };
}
