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
    {
      # Kmonad's config lang
      name = "kbd";
      scope = "source.kbd";
      injection-regex = "kbd";
      file-types = [ "kbd" ];
      roots = [ ];
      comment-token = ";;";
      indent = {
        tab-width = 2;
        unit = "  ";
      };
    }
  ];
}
