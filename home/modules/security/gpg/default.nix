{ config, pkgs, ... }:

{
  # To have emacs gpg passphrase in minibuffer, let both gpg and gpg-agent to
  # accept loopback pinentry.
  # https://lists.nongnu.org/archive/html/emacs-devel/2022-08/msg00746.html

  programs.gpg = {
    enable = true;
    # Remove this after this PR is merged.
    # https://github.com/NixOS/nixpkgs/pull/245479
    package = pkgs.stable.gnupg;
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    extraConfig = ''
      allow-emacs-pinentry
      allow-loopback-pinentry
    '';
  };
}
