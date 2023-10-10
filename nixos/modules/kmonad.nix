{
  services.kmonad = {
    enable = true; # disable to not run kmonad at startup
    keyboards = {
      "laptop-internal" = {
        device = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";
        defcfg = {
          enable = true;
          fallthrough = true;
        };

        config = ''
          ;; I spent hours to get zenkaku_hankaku to be remapped to CapsLock,
          ;; but every single attempt with both kmonad and keyd failed. It
          ;; seems that pressing performing the action defined by kmonad or
          ;; keyd that is supposed to send the zenkaku_hankaku keycode does not
          ;; send it.
          ;; 
          ;; It turns out that zenkaku_hankaku is a bit of a problemetic key.
          ;; In a X session, it is known to misbehave by repeatedly seding
          ;; key-press signals indefinitely. I have no idea how Wayland
          ;; inherited this problem, but I came across a few reports of
          ;; zenkaku_hankaku not responding on Wayland, though the reports were
          ;; found in issue pages of projects whose goals are not to provide
          ;; key-remapping on X nor Wayland, so the cause of the issues might
          ;; be unrelated to that of mine.
          ;;
          ;; Anyway, I found a workaround. Kmonad allows to define a "modded"
          ;; key, which is just normal a key preceded by a modifier. So, I can
          ;; map caps to ctrl-\. With this I can activate an IME in emacs with
          ;; a single tap of caps.

          (defsrc
            esc  mute vold volu                                    home end  ins  del
                 f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12  
            grv  1    2    3    4    5    6    7    8    9    0    -     =    bspc
            tab  q    w    e    r    t    y    u    i    o    p    [     ]    \
            caps a    s    d    f    g    h    j    k    l    ;    '          ret
            lsft z    x    c    v    b    n    m    ,    .    /               rsft
            wkup lctl lmet lalt           spc            ralt prnt rctl  pgdn up   pgup
                                                                         left down rght
          )

          (deflayer qwerty
            esc  mute vold volu                                    home end  ins  del
                 f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12  
            grv  1    2    3    4    5    6    7    8    9    0    -     =    bspc
            tab  q    w    e    r    t    y    u    i    o    p    [     ]    \
            C-\  a    s    d    f    g    h    j    k    l    ;    '          ret
            lsft z    x    c    v    b    n    m    ,    .    /               rsft
            wkup lctl lmet lalt           spc            ralt prnt rctl  pgdn up   pgup
                                                                         left down rght
          )
        '';
      };
    };
  };
}
