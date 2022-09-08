{
  # Ls but looks nicer
  ls = "exa -la";

  # What even is this???
  sl = "sl -e";

  # WIfi stuff
  wifi = "sudo nmcli con up id";

  # Volume controls
  "v-up" = "pactl set-sink-volume @DEFAULT_SINK@ +5%";
  "v-down" = "pactl set-sink-volume @DEFAULT_SINK@ +5%";
  "v-min" = "pactl set-sink-volume @DEFAULT_SINK@ 0%";
  "v-mid" = "pactl set-sink-volume @DEFAULT_SINK@ 50%";
  "v-max" = "pactl set-sink-volume @DEFAULT_SINK@ 100%";
  # "v-up" = "amixer set Master 8%+";
  # "v-down" = "amixer set Master 8%-";
  # "v-min" = "amixer set Master 0%";
  # "v-mid" = "amixer set Master 50%";
  # "v-max" = "amixer set Master 100%";

  # Print available battery
  battery = "acpi";

  # Rebuuild nixos
  rebuild = "sudo -u adrielus nixos-rebuild switch --flake ~/Projects/nixos-config/";

  # Render git repo using gource
  "git-render" = "gource -f -s 1 -c 4 --key";
}
