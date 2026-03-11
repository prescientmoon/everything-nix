{ config, lib, ... }:
let
  configSource = builtins.readFile ./config.kanata;

  mkConfig =
    {
      blueTrigger,
      redTrigger,
      chordDelay,
    }:
    builtins.replaceStrings
      # Kanata variables cannot appear inside defsrc, so we bake them in
      [ "$BLUE" "$RED" "$CHORD_DELAY" ]
      # Adding a comment here to please the formatter :3
      [ blueTrigger redTrigger (toString chordDelay) ]
      configSource;

  extraDefCfg = ''
    concurrent-tap-hold true ;; Required by chords
    rapid-event-delay 20     ;; Attempt to make foot happy, I guess
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
