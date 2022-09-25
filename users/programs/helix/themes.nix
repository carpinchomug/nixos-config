{
  programs.helix.themes = {
    my_theme =
      let
        base = "#191724";
        surface = "#1f1d2e";
        overlay = "#26233a";
        muted = "#6e6a86";
        subtle = "#6e6a86";
        text = "#e0def4";
        love = "#eb6f92";
        gold = "#f6c177";
        rose = "#ebbcba";
        pine = "#31748f";
        foam = "#9ccfd8";
        iris = "#c4a7e7";
        highlight = "#21202e";
        highlightMed = "#403d52";
        highlightHigh = "#524f67";

      in
      {
        "type" = foam;
        # "type.builtin"
        "constructor" = gold;
        "constant" = gold;
        # "constant.builtin"
        # "constant.builtin.boolean"
        # "constant.character"
        "constant.character.escape" = muted;
        "constant.numeric" = iris;
        # "constant.numeric.integer"
        # "constant.numeric.float"
        "string" = gold;
        # "string.regexp"
        # "string.special"
        # "string.special.path"
        # "string.special.url"
        # "string.special.symbol"
        "comment" = subtle;
        # "comment.line"
        # "comment.block"
        # "comment.block.documentation"
        "variable" = text;
        # "variable.builtin"
        # "variable.parameter"
        # "variable.other"
        # "variable.other.member"
        # "variable.function"
        "label" = iris;
        # "punctuation"
        # "punctuation.delimiter"
        # "punctuation.bracket"
        "keyword" = pine;
        # "keyword.control"
        # "keyword.control.conditional"
        # "keyword.control.repeat"
        # "keyword.control.import"
        # "keyword.control.return"
        # "keyword.control.exception"
        # "keyword.operator"
        # "keyword.directive"
        # "keyword.function"
        "operator" = rose;
        "function" = rose;
        "function.builtin" = rose;
        "function.method" = foam;
        # "function.macro"
        # "function.special"
        # "tag"
        "namespace" = pine;

        "markup.heading.marker" = subtle;
        "markup.heading.1" = { fg = love; modifiers = [ "bold" ]; };
        "markup.heading.2" = { fg = gold; modifiers = [ "bold" ]; };
        "markup.heading.3" = { fg = rose; modifiers = [ "bold" ]; };
        "markup.heading.4" = { fg = pine; modifiers = [ "bold" ]; };
        "markup.heading.5" = { fg = foam; modifiers = [ "bold" ]; };
        "markup.heading.6" = { fg = text; modifiers = [ "bold" ]; };
        "markup.list" = love;
        # "markup.list.unnumbered"
        # "markup.list.numbered"
        "markup.bold" = { fg = gold; modifiers = [ "bold" ]; };
        "markup.italic" = { fg = iris; modifiers = [ "italic" ]; };
        "markup.link.url" = { fg = pine; modifiers = [ "underlined" ]; };
        # "markup.link.label"
        "markup.link.text" = foam;
        "markup.quote" = rose;
        "markup.raw" = foam;
        # "markup.raw.inline"
        # "markup.raw.block"

        "diff.plus" = foam;
        "diff.minus" = love;
        "diff.delta" = rose;
        # "diff.delta.moved"

        # "ui.background"
        "ui.cursor" = { modifiers = [ "reversed" ]; };
        # "ui.cursor.insert"
        # "ui.cursor.select"
        "ui.cursor.match" = gold;
        # "ui.cursor.primary"
        "ui.linenr" = subtle;
        "ui.linenr.selected" = text;
        "ui.statusline" = foam;
        "ui.statusline.inactive" = pine;
        "ui.popup" = { fg = text; bg = overlay; };
        "ui.popup.info" = text;
        "ui.window" = highlightHigh;
        "ui.help" = text;
        "ui.text" = text;
        "ui.text.focus" = { fg = foam; modifiers = [ "bold" ]; };
        "ui.text.info" = { fg = pine; modifiers = [ "bold" ]; };
        "ui.menu" = { fg = text; bg = overlay; };
        "ui.menu.selected" = foam;
        "ui.selection" = { bg = highlightMed; };
        # "ui.selection.primary"
        # "ui.virtual.ruler"
        "ui.virtual.whitespace" = muted;

        "error" = love;
        "warning" = gold;
        "info" = iris;
        "hint" = text;
        "diagnostic" = { modifiers = [ "underlined" ]; };

        "special" = iris;
      };
  };
}
