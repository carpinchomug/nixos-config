{ pkgs, ... }:

{
  programs.firefox = {
    enable = true;
    profiles = {
      default = {
        isDefault = true;
        settings = {
          "browser.shell.checkDefaultBrowser" = false;
          "browser.fullscreen.autohide" = false;
          "signon.rememberSignons" = false;
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "svg.context-properties.content.enabled" = true;
          "layers.acceleration.force-enabled" = true;
        };
        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          browserpass
          ublock-origin
          vimium
        ];
        userChrome = ''
          @import "${pkgs.firefox-gnome-theme}/share/userChrome.css"
        '';
        userContent = ''
          @import "${pkgs.firefox-gnome-theme}/share/userContent.css"
        '';
      };
    };
  };
}
