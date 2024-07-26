{ ... }:
let
  stickTap = action: "tap-hold-press 0 200 (one-shot-press-pcancel 1000 (${action})) (${action})";
  mkConfig = { blueTrigger, redTrigger, chordDelay }: '' 
    ;; {{{ Source layout
    (defsrc
      grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
      tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
      caps a    s    d    f    g    h    j    k    l    ;    '    ret
      lsft z    x    c    v    b    n    m    ,    .    /    rsft
      lctl lmet ${redTrigger}           spc            ${blueTrigger}
    )
    ;; }}}
    ;; {{{ Layer & utility aliases
    (defalias
      red (layer-while-held red)
      blue (layer-while-held blue)
      purple (layer-while-held purple)

      em (unicode —)
    )
    ;; }}}
    (defchordsv2-experimental
      ;; {{{ Left modifiers
      (a s d f) (multi lctl lalt lsft) ${toString chordDelay} all-released ()
      (a s d  ) (multi lalt lsft) ${toString chordDelay} all-released ()
      (  s d f) (multi lctl lsft) ${toString chordDelay} all-released ()
      (a s    ) lalt ${toString chordDelay} all-released ()
      (  s d  ) lsft ${toString chordDelay} all-released ()
      (  s   f) lctl ${toString chordDelay} all-released ()
      ;; }}}
      ;; {{{ Right modifiers
      (j k l ;) (multi rctl ralt rsft) ${toString chordDelay} all-released ()
      (j k l  ) (multi rctl rsft) ${toString chordDelay} all-released ()
      (  k l ;) (multi ralt rsft) ${toString chordDelay} all-released ()
      (j   l  ) rctl ${toString chordDelay} all-released ()
      (  k l  ) rsft ${toString chordDelay} all-released ()
      (    l ;) ralt ${toString chordDelay} all-released ()
      ;; }}}
      ;; {{{ Special keys
      (d f) tab ${toString chordDelay} all-released ()
      (e f) ret ${toString chordDelay} all-released ()
      (q w) esc ${toString chordDelay} all-released ()

      (g h) bspc ${toString chordDelay} all-released ()
      (n l) rmet ${toString chordDelay} all-released ()

      (j k) f10 ${toString chordDelay} all-released ()
      (c p) f11 ${toString chordDelay} all-released ()
      (j i) f12 ${toString chordDelay} all-released ()
      ;; }}}
      ;; {{{ Wm keybinds
      (n l k) M-p ${toString chordDelay} all-released ()
      (n l q) M-1 ${toString chordDelay} all-released ()
      (n l w) M-2 ${toString chordDelay} all-released ()
      (n l e) M-3 ${toString chordDelay} all-released ()
      (n l r) M-4 ${toString chordDelay} all-released ()
      (n l t) M-5 ${toString chordDelay} all-released ()
      (n l a) M-6 ${toString chordDelay} all-released ()
      (n l s) M-7 ${toString chordDelay} all-released ()
      (n l d) M-8 ${toString chordDelay} all-released ()
      (n l f) M-9 ${toString chordDelay} all-released ()
      (n l g) M-0 ${toString chordDelay} all-released ()
      ;; }}}
    )

    ;; {{{ Qwerty
    (deflayer qwerty
      XX   XX   XX   XX   XX   XX   XX   XX   XX   XX   XX   XX   XX   XX
      XX   q    w    e    r    t    y    u    i    o    p    XX   XX   XX
      XX   a    s    d    f    g    h    j    k    l    ;    XX   XX
      lsft z    x    c    v    b    n    m    ,    .    '    XX
      XX   lmet @red           spc           @blue
    )
    ;; }}}
    ;; {{{ Transparent template
    (deflayer template
      _    _    _    _    _    _    _    _    _    _    _    _    _    _
      _    _    _    _    _    _    _    _    _    _    _    _    _    _
      _    _    _    _    _    _    _    _    _    _    _    _    _
      _    _    _    _    _    _    _    _    _    _    _    _
      _    _    _              _              _
    )
    ;; }}}
    ;; {{{ Blue
    (deflayer blue
      _    _    _    _    _    _    _    _    _    _    _    _    _    _
      _    S-=  S-2  S-3  S-4  S-5  S--  S-7  S-8  grv S-grv _    _    _
      _    S-,  S-[  [    S-9  S-/  S-\  -    /    =    S-;  _    _
      _    S-.  S-]  ]    S-0  S-1  @em  S-6  _    _    S-'  _
      _    _    @purple        \              _
    )
    ;; }}}
    ;; {{{ Red
    (deflayer red
      _    _    _    _    _    _    _    _    _    _    _    _    _    _
      _    1    2    3    4    5    home pgdn pgup end  del  _    _    _
      _    6    7    8    9    0    left down up   rght _    _    _
      _    _    _    _    _    _    _    _    _    _    _    _
      _    _    _              _           @purple
    )
    ;; }}}
    ;; {{{ Purple
    (defalias
      ;; Press once to active caps lock for a word (revert after being idle 
      ;; for 2s), or twice for real caps lock.
      cps (tap-dance 200 ((caps-word 2000) caps))
      udo (arbitrary-code 131) ;; undo
      cpy (arbitrary-code 133) ;; copy
      pst (arbitrary-code 135) ;; paste
      cut (arbitrary-code 137) ;; cut
    )

    (deflayer purple
      _    _    _    _    _    _    _    _    _    _    _    _    _    _
      _    f1   f2   f3   f4   f5   @cps @cpy next volu brup _    _    _
      _    f6   f7   f8   f9   f10  @udo @pst pp   vold brdn _    _
      _    f11  f12  _    _    _    _    @cut prev mute _    _
      _    _    _              _              _
    )
    ;; }}}
  '';

  extraDefCfg = ''
    concurrent-tap-hold true ;; Required by chords
  '';
in
{
  services.kanata = {
    enable = true;
    keyboards.tethysLaptop = {
      inherit extraDefCfg;

      devices = [ "/dev/input/by-path/platform-i8042-serio-0-event-kbd" ];

      config = mkConfig {
        redTrigger = "lalt";
        blueTrigger = "ralt";
        chordDelay = 25;
      };
    };

    keyboards.keychronK6 = {
      inherit extraDefCfg;

      devices = [ "/dev/input/by-id/usb-Keychron_Keychron_K6-event-kbd" ];

      config = mkConfig {
        redTrigger = "lalt";
        blueTrigger = "rctl";
        chordDelay = 30;
      };
    };
  };
}
