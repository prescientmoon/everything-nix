{
  security.rtkit.enable = true;
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Volume controls
  environment.shellAliases = {
    # Relative 
    "v-up" = "pactl set-sink-volume @DEFAULT_SINK@ +5%";
    "v-down" = "pactl set-sink-volume @DEFAULT_SINK@ +5%";

    # Absolute
    "v-min" = "pactl set-sink-volume @DEFAULT_SINK@ 0%";
    "v-mid" = "pactl set-sink-volume @DEFAULT_SINK@ 50%";
    "v-max" = "pactl set-sink-volume @DEFAULT_SINK@ 100%";
  };
}
