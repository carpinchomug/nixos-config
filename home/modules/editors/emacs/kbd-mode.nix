{ trivialBuild
, fetchFromGitHub
}:

trivialBuild {
  pname = "kbd-mode";
  version = "2023-09-24";

  src = fetchFromGitHub {
    owner = "kmonad";
    repo = "kbd-mode";
    rev = "b9048e928ac403c8a1cf09b4fec75776dc4ecf4f";
    hash = "sha256-YhVUOlUNhWmHQZLI4vCegKPD0/CDD9Dxh3aLrJUyneU=";
  };
}
