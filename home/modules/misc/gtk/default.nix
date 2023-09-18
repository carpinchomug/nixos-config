{ outputs, pkgs, ... }:

{
  gtk = {
    enable = true;

    theme = {
      name = "adw-gtk3";
      package = pkgs.adw-gtk3;
    };

    iconTheme = {
      name = "Adwaita";
      package = pkgs.gnome.adwaita-icon-theme;
    };

    cursorTheme = {
      name = "capitaine-cursors";
      package = pkgs.capitaine-cursors;
      size = 24;
    };
  };
}
