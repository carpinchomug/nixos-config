{
  programs.chromium = {
    enable = true;

    extensions = [
      # bitwarden
      # https://chrome.google.com/webstore/detail/bitwarden-free-password-m/nngceckbapebfimnlniiiahkandclblb
      { id = "nngceckbapebfimnlniiiahkandclblb"; }

      # json viewer
      # https://chrome.google.com/webstore/detail/json-viewer/gbmdgpbipfallnflgajpaliibnhdgobh
      { id = "gbmdgpbipfallnflgajpaliibnhdgobh"; }

      # line
      # https://chrome.google.com/webstore/detail/line/ophjlpahpchlmihnnnihgmmeilfjmjjc
      { id = "ophjlpahpchlmihnnnihgmmeilfjmjjc"; }

      # react developer tools
      # https://chrome.google.com/webstore/detail/react-developer-tools/fmkadmapgofadopljbjfkapdkoienihi
      { id = "fmkadmapgofadopljbjfkapdkoienihi"; }

      # vimium
      # https://chrome.google.com/webstore/detail/vimium/dbepggeogbaibhgnhhndojpepiihcmeb
      { id = "dbepggeogbaibhgnhhndojpepiihcmeb"; }
    ];
  };
}
