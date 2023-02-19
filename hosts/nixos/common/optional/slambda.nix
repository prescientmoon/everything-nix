let
  chord = from: to: { inherit from to; };
  unmap = from: chord from [ ];
  commonChords = [
    # {{{ Modifiers
    (chord [ "s" "d" ] [ "leftshift" ])
    (chord [ "k" "l" ] [ "rightshift" ])
    (chord [ "s" "f" ] [ "leftctrl" ])
    (chord [ "j" "l" ] [ "rightctrl" ])
    (chord [ "j" "k" "l" ] [ "rightctrl" "rightshift" ])
    (chord [ "s" "d" "f" ] [ "leftctrl" "leftshift" ])
    (chord [ "n" "l" ] [ "leftmeta" ])
    (unmap [ "leftmeta" ])
    (unmap [ "leftshift" ])
    (unmap [ "rightshift" ])
    (unmap [ "leftctrl" ])
    (unmap [ "rightctrl" ])
    # }}}
    # {{{ Other special keys
    (chord [ "g" "h" ] [ "backspace" ])
    (chord [ "n" "v" ] [ "backslash" ])
    (chord [ "d" "f" ] [ "tab" ])
    (chord [ "e" "f" ] [ "enter" ])
    (chord [ "q" "w" ] [ "esc" ])
    (unmap [ "backspace" ])
    (unmap [ "enter" ])
    (unmap [ "tab" ])
    (unmap [ "esc" ])
    (unmap [ "backslash" ])
    # }}}
    # {{{ Tmux
    (chord [ "a" "n" "k" "l" ] [ "leftctrl" "a" "n" ]) # Next tab in tmux
    (chord [ "a" "j" "l" ] [ "leftctrl" "a" ]) # Tmux leader
    # }}}
    # {{{ WM keybinds
    (chord [ "n" "l" "q" ] [ "leftmeta" "1" ])
    (chord [ "n" "l" "w" ] [ "leftmeta" "2" ])
    (chord [ "n" "l" "e" ] [ "leftmeta" "3" ])
    (chord [ "n" "l" "r" ] [ "leftmeta" "4" ])
    (chord [ "n" "l" "a" ] [ "leftmeta" "5" ])
    (chord [ "n" "l" "s" ] [ "leftmeta" "6" ])
    (chord [ "n" "l" "d" ] [ "leftmeta" "7" ])
    (chord [ "n" "l" "f" ] [ "leftmeta" "8" ])
    (chord [ "n" "k" "l" ] [ "leftmeta" "p" ])
    # }}}
    # {{{ Handled by vim
    (chord [ "j" "k" ] [ "f10" ])
    (chord [ "c" "p" ] [ "f11" ])
    (chord [ "j" "i" ] [ "f12" ])
    # }}}
  ];
in
{
  services.slambda = {
    enable = true;

    keyboards.keychronK6 = {
      delay = 25;
      device = "/dev/input/by-id/usb-Keychron_Keychron_K6-event-kbd";
      chords = commonChords;
    };

    keyboards.tethysLaptop = {
      delay = 25;
      device = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";
      chords = commonChords;
    };
  };
}
