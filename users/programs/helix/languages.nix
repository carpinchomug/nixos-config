{
  programs.helix.languages = [
    {
      name = "latex";
      scope = "source.tex";
      injection-regex = "tex";
      file-types = [ "tex" "bib" ];
      roots = [ ".latexmkrc" ".git" ];
      comment-token = "%";
      language-server = { command = "texlab"; };
      indent = { tab-width = 4; unit = "    "; };
    }
  ];
}
