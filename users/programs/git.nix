{
  programs.git = {
    enable = true;

    userEmail = "aki.suda@protonmail.com";
    userName = "Akiyoshi Suda";

    extraConfig = {
      init.defaultBranch = "main";
      core.editor = "hx";
    };
  };
}
