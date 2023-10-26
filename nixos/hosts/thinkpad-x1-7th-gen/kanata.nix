{
  services.kanata = {
    enable = true; # disable to not run kmonad at startup
    keyboards = {
      "laptop-internal" = {
        devices = [ "/dev/input/by-path/platform-i8042-serio-0-event-kbd" ];

        extraDefCfg = ''
          process-unmapped-keys yes
        '';

        config = ''
          ;; (deflayer template
          ;;   _    _    _    _    _    _    _    _    _    _    _    _    _    _    _    _    _
          ;;   _    _    _    _    _    _    _    _    _    _    _    _    _    _
          ;;   _    _    _    _    _    _    _    _    _    _    _    _    _    _
          ;;   _    _    _    _    _    _    _    _    _    _    _    _         _
          ;;   _    _    _    _    _    _    _    _    _    _    _              _
          ;;   _    _    _    _              _              _    _    _    _    _    _
          ;;                                                               _    _    _
          ;; )

          (defsrc
            esc  f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12  home end  ins  del
            grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
            tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
            caps a    s    d    f    g    h    j    k    l    ;    '         ret
            lsft z    x    c    v    b    n    m    ,    .    /              rsft
            wkup lctl lmet lalt           spc            ralt prnt rctl pgdn up   pgup
                                                                        left down rght
          )

          (deflayer base
            esc  f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12  home end  ins  del
            grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
            tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
            @cps a    s    d    f    g    h    j    k    l    ;    '         ret
            lsft z    x    c    v    b    n    m    ,    .    /              rsft
            wkup lctl lmet lalt           spc            ralt @prm rctl pgdn up   pgup
                                                                        left down rght
          )

          (deflayer sticky
            _    _    _    _    _    _    _    _    _    _    _    _    _    _    _    _    _
            _    _    _    _    _    _    _    _    _    _    _    _    _    _
            _    _    _    _    _    _    _    _    _    _    _    _    _    _
            _    _    _    _    _    _    _    @j   @k   @l   @;   _         _
            _    _    _    _    _    _    _    _    _    _    _              _
            _    _    _    _              _              _    _    _    _    _    _
                                                                        _    _    _
          )

          (defalias
            prm (multi XX (tap-hold-release 200 200 prnt rmet))

            cps (multi XX (tap-hold-press 200 200 C-\ (layer-while-held sticky)))

            ;; `on-press-fakekey <key> toggle` will be available in the next release.
            ;; a (tap-dance 200 ((one-shot-press 2000 lmet) (fork (on-press-fakekey met press) (on-press-fakekey met release) (lmet))))
            ;; s (tap-dance 200 ((one-shot-press 2000 lalt) (fork (on-press-fakekey alt press) (on-press-fakekey alt release) (lalt))))
            ;; d (tap-dance 200 ((one-shot-press 2000 lctl) (fork (on-press-fakekey ctl press) (on-press-fakekey ctl release) (lctl))))
            ;; f (tap-dance 200 ((one-shot-press 2000 lsft) (fork (on-press-fakekey sft press) (on-press-fakekey sft release) (lsft))))
            j (tap-dance 200 ((one-shot-press 2000 lsft) (fork (on-press-fakekey sft press) (on-press-fakekey sft release) (lsft))))
            k (tap-dance 200 ((one-shot-press 2000 lctl) (fork (on-press-fakekey ctl press) (on-press-fakekey ctl release) (lctl))))
            l (tap-dance 200 ((one-shot-press 2000 lalt) (fork (on-press-fakekey alt press) (on-press-fakekey alt release) (lalt))))
            ; (tap-dance 200 ((one-shot-press 2000 lmet) (fork (on-press-fakekey met press) (on-press-fakekey met release) (lmet))))
          )

          (deffakekeys
            sft lsft
            ctl lctl
            alt lalt
            met lmet
          )
        '';
      };
    };
  };
}
