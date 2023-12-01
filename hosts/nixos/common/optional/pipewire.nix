# This handles audio stuff
{ pkgs, ... }: {
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
  environment.shellAliases =
    let
      pactl = "${pkgs.pulseaudio}/bin/pactl";
      volume = amount: "${pactl} set-sink-volume @DEFAULT_SINK@ ${amount}";
    in
    {
      # Relative 
      "v-down" = volume "-5%";
      "v-up" = volume "+5%";

      # Absolute
      "v-min" = volume "0%";
      "v-low" = volume "25%";
      "v-mid" = volume "50%";
      "v-high" = volume "75%";
      "v-max" = volume "100%";
    };
}
