let
  chord = from: to: { inherit from to; };
  unmap = from: chord from [ ];
  # I want my brackets to be aligned
  sem = "semicolon";
  commonChords = [
    # {{{ Modifiers
    # {{{ right
    (chord [ "l" "n" ] [ "rightmeta" ])
    (chord [ "k" "l" ] [ "rightshift" ])
    (chord [ "j" "l" ] [ "rightctrl" ])
    (chord [ "l" sem ] [ "rightalt" ])
    (chord [ "j" "k" "l" ] [ "rightctrl" "rightshift" ])
    (chord [ "k" "l" sem ] [ "rightalt" "rightshift" ])
    (chord [ "j" "k" "l" sem ] [ "rightalt" "rightctrl" "rightshift" ])
    (unmap [ "rightshift" ])
    (unmap [ "rightctrl" ])
    (unmap [ "rightalt" ])
    (unmap [ "rightmeta" ])
    # }}}
    # {{{ left
    (chord [ "s" "d" ] [ "leftshift" ])
    (chord [ "s" "f" ] [ "leftctrl" ])
    (chord [ "s" "a" ] [ "leftalt" ])
    (chord [ "s" "d" "f" ] [ "leftctrl" "leftshift" ])
    (chord [ "a" "s" "d" ] [ "leftalt" "leftshift" ])
    (chord [ "a" "s" "d" "f" ] [ "leftalt" "leftctrl" "leftshift" ])
    (unmap [ "leftalt" ])
    (unmap [ "leftctrl" ])
    # (unmap [ "leftshift" ]) # Useful for touhou
    # }}}
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
    (chord [ "n" "l" "z" ] [ "leftmeta" "9" ])
    (chord [ "n" "l" "x" ] [ "leftmeta" "0" ])
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
      delay = 30;
      device = "/dev/input/by-id/usb-Keychron_Keychron_K6-event-kbd";
      chords = commonChords;
    };

    keyboards.tethysLaptop = {
      delay = 30;
      device = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";
      chords = commonChords;
    };
  };
}
