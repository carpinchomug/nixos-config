{
  programs.zathura = {
    enable = true;

    options = {
      recolor = true;
      recolor-keephue = true;
    };

    extraConfig = ''
      ${builtins.readFile ./rose-pine-dawn}
    '';
  };
}
