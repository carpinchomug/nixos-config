{ trivialBuild
, fetchFromSourcehut
}:

trivialBuild {
  pname =  "typst-ts-mode";
  version = "2023-10-07";

  src = fetchFromSourcehut {
    owner = "~meow_king";
    repo = "typst-ts-mode";
    rev = "9d1adbcb0931bb68ad648800c51fdd457398f9ec";
    hash = "sha256-P/4Igv49rQ1ZpjbGeAlPRzWK08azbxxhgXhbaKAvfUg=";
  };
}
