{
  programs.helix = {
    enable = true;

    settings = {
      editor = {
        line-number = "relative";
        cursor-shape.insert = "bar";
      };
      keys = {
        normal = {
          "C-h" = "jump_view_left";
          "C-j" = "jump_view_down";
          "C-k" = "jump_view_up";
          "C-l" = "jump_view_right";
        };
      };
    };
  };
}