{ pkgs, ... }:

{
  programs.git = {
    userName = "Akiyoshi Suda";
    userEmail = "aki.suda@protonmail.com";
    signing = {
      key = "B68A 3500 A660 DC37 523E  2F88 5BF1 50EB 6DDE AE9B";
      signByDefault = true;
    };
  };

  programs.ssh = {
    matchBlocks = {
      "github" = {
        host = "github.com";
        hostname = "github.com";
        identityFile = "~/.ssh/gpg.pub";
      };
    };
  };

  programs.helix.defaultEditor = true;
  # services.emacs.defaultEditor = true;

  services.gpg-agent = {
    # This requires `services.dbus.packages = [ pkgs.gcr ];` in the system
    # config on a non-Gnome system.
    pinentryFlavor = "gnome3";
    sshKeys = [
      "B3212A90CD0AF710E2A208985F7E6ACEE82E0EE9"
    ];
  };

  wayland.windowManager.sway = {
    config = {
      input = {
        "1:1:AT_Translated_Set_2_keyboard" = {
          xkb_layout = "us";
          xkb_variant = "altgr-intl";
          xkb_options = "lv3:caps_switch,lv3:ralt_alt";
        };

        "type:touchpad" = {
          tap = "enabled";
          natural_scroll = "enabled";
        };
      };

      # output = {
      #   "*" = {
      #     bg = "${builtins.toString ../../assets/wallpapers/lake-tree.png} fill";
      #   };
      # };
    };
  };
}
