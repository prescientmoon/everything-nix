{ config, lib, ... }:
# TODO: only enable this on "interactible" systems (i.e. systems I have physical
# access to)
let
  # stickTap = action: "tap-hold-press 0 200 (one-shot-press-pcancel 1000 (${action})) (${action})";

  mkConfig =
    {
      blueTrigger,
      redTrigger,
      chordDelay,
    }:
    ''
      ;; {{{ Source layout
      (defsrc
        grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
        tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
        caps a    s    d    f    g    h    j    k    l    ;    '    ret
        lsft z    x    c    v    b    n    m    ,    .    /    rsft
        lctl lmet ${redTrigger}           spc            ${blueTrigger}
      )
      ;; }}}

      (defalias
        ;; {{{ Layers
        red           (layer-while-held red)
        blue          (layer-while-held blue)
        purple        (layer-while-held purple)
        unicode-1     (layer-while-held unicode-1)
        double-stroke (layer-while-held double-stroke)
        lower-greek   (layer-while-held lowercase-greek)
        upper-greek   (layer-while-held uppercase-greek)
        ;; }}}
        ;; {{{ Unicode
        em (unicode —)
        ⟨ (unicode ⟨)
        ⟩ (unicode ⟩)
        ‹ (unicode ‹)
        › (unicode ›)
        ⋄ (unicode ⋄)
        ∞ (unicode ∞)
        ≔ (unicode ≔)
        ≤ (unicode ≤)
        ≥ (unicode ≥)
        ∈ (unicode ∈)
        ∘ (unicode ∘)
        ¬ (unicode ¬)
        ∃ (unicode ∃)
        ∀ (unicode ∀)
        ⊤ (unicode ⊤)
        ⊥ (unicode ⊥)
        ⊣ (unicode ⊣)
        ⊢ (unicode ⊢)
        ∧ (unicode ∧)
        ∨ (unicode ∨)

        𝔸 (unicode 𝔸)
        𝔹 (unicode 𝔹)
        ℂ (unicode ℂ)
        ⅅ (unicode ⅅ)
        𝔼 (unicode 𝔼)
        𝔽 (unicode 𝔽)
        𝔾 (unicode 𝔾)
        ℍ (unicode ℍ)
        𝕀 (unicode 𝕀)
        𝕁 (unicode 𝕁)
        𝕂 (unicode 𝕂)
        𝕃 (unicode 𝕃)
        𝕄 (unicode 𝕄)
        ℕ (unicode ℕ)
        𝕆 (unicode 𝕆)
        ℙ (unicode ℙ)
        ℚ (unicode ℚ)
        ℝ (unicode ℝ)
        𝕊 (unicode 𝕊)
        𝕋 (unicode 𝕋)
        𝕌 (unicode 𝕌)
        𝕍 (unicode 𝕍)
        𝕎 (unicode 𝕎)
        𝕏 (unicode 𝕏)
        𝕐 (unicode 𝕐)
        ℤ (unicode ℤ)

        φ (unicode φ)
        ω (unicode ω)
        ε (unicode ε)
        ρ (unicode ρ)
        τ (unicode τ)
        ψ (unicode ψ)
        υ (unicode υ)
        ι (unicode ι)
        ο (unicode ο)
        π (unicode π)
        α (unicode α)
        σ (unicode σ)
        δ (unicode δ)
        ς (unicode ς)
        γ (unicode γ)
        η (unicode η)
        θ (unicode θ)
        κ (unicode κ)
        λ (unicode λ)
        ζ (unicode ζ)
        ξ (unicode ξ)
        χ (unicode χ)
        β (unicode β)
        ν (unicode ν)
        μ (unicode μ)

        Φ (unicode Φ)
        Ω (unicode Ω)
        Ε (unicode Ε)
        Ρ (unicode Ρ)
        Τ (unicode Τ)
        Ψ (unicode Ψ)
        Υ (unicode Υ)
        Ι (unicode Ι)
        Ο (unicode Ο)
        Π (unicode Π)
        Α (unicode Α)
        Σ (unicode Σ)
        Δ (unicode Δ)
        Γ (unicode Γ)
        Η (unicode Η)
        Θ (unicode Θ)
        Κ (unicode Κ)
        Λ (unicode Λ)
        Ζ (unicode Ζ)
        Ξ (unicode Ξ)
        Χ (unicode Χ)
        Β (unicode Β)
        Ν (unicode Ν)
        Μ (unicode Μ)
        ;; }}}
      )

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
        ;; {{{ Extra layers
        (u i o) @upper-greek   ${toString (chordDelay - 5)} all-released ()
        (w e r) @upper-greek   ${toString (chordDelay - 5)} all-released ()
        (i o)   @lower-greek   ${toString (chordDelay - 5)} all-released ()
        (w e)   @lower-greek   ${toString (chordDelay - 5)} all-released ()
        (u i)   @unicode-1     ${toString (chordDelay - 5)} all-released ()
        (e r)   @unicode-1     ${toString (chordDelay - 5)} all-released ()
        (u o)   @double-stroke ${toString (chordDelay - 5)} all-released ()
        (w r)   @double-stroke ${toString (chordDelay - 5)} all-released ()
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
      ;; {{{ Unicode
      (deflayer unicode-1
        _    _    _    _    _    _    _    _    _    _    _    _    _    _
        _    @⋄   @∞   _    _    _    _    _    @∘   @≔   _    _    _    _
        _    @≤   @∧   @‹   @⟨   _    @⊢   @⊥   @⊤   @⊣   _    _    _
        _    @≥   @∨   @›   @⟩   @¬   _    _    @∀   @∃   _    _
        _    _    _              _              _
      )

      ;; (deflayer unicode-sets
      ;;   _    _    _    _    _    _    _    _    _    _    _    _    _    _
      ;;   _    _    _    _    _    _    _    _    _    _    _    _    _    _
      ;;   _    @⊆   @⊂   @∈   _    _    _    _    _    _    _    _    _
      ;;   _    @⊇   @⊃   _    _    _    _    _    _    _    _    _
      ;;   _    _    _              _              _
      ;; )

      (deflayer double-stroke
        _    _    _    _    _    _    _    _    _    _    _    _    _    _
        _    @ℚ   @𝕎   @𝔼   @ℝ   @𝕋   @𝕐   @𝕌   @𝕀   @𝕆   @ℙ   _    _    _
        _    @𝔸   @𝕊   @ⅅ   @𝔽   @𝔾   @ℍ   @𝕁   @𝕂   @𝕃   _    _    _
        _    @ℤ   @𝕏   @ℂ   @𝕍   @𝔹   @ℕ   @𝕄   _    _    _    _
        _    _    _              _              _
      )

      (deflayer lowercase-greek
        _    _    _    _    _    _    _    _    _    _    _    _    _    _
        _    @φ   @ω   @ε   @ρ   @τ   @ψ   @υ   @ι   @ο   @π   _    _    _
        _    @α   @σ   @δ   @ς   @γ   @η   @θ   @κ   @λ   _    _    _
        _    @ζ   @ξ   @χ   _    @β   @ν   @μ   _    _    _    _
        _    _    _              _              _
      )

      (deflayer uppercase-greek
        _    _    _    _    _    _    _    _    _    _    _    _    _    _
        _    @Φ   @Ω   @Ε   @Ρ   @Τ   @Ψ   @Υ   @Ι   @Ο   @Π   _    _    _
        _    @Α   @Σ   @Δ   _    @Γ   @Η   @Θ   @Κ   @Λ   _    _    _
        _    @Ζ   @Ξ   @Χ   _    @Β   @Ν   @Μ   _    _    _    _
        _    _    _              _              _
      )
      ;; }}}
    '';

  extraDefCfg = ''
    concurrent-tap-hold true ;; Required by chords
    rapid-event-delay 20 ;; Attempt to make foot happy, I guess
  '';
in
{
  services.kanata = lib.mkIf config.satellite.machine.interactible {
    enable = true;

    # I called this "tethysLaptop" (since it was originally written for the
    # tethys laptop), but seems to work for the calypso
    # and lapetus laptops as well
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
