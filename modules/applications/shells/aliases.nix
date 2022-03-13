{
  # Ls but looks nicer
  ls = "exa -la";

  # What even is this???
  sl = "sl -e";

  # WIfi stuff
  wifi = "sudo nmcli con up id";

  # Volume controls
  "v-up" = "amixer set Master 8%+";
  "v-down" = "amixer set Master 8%-";
  "v-min" = "amixer set Master 0%";
  "v-mid" = "amixer set Master 50%";
  "v-max" = "amixer set Master 100%";

  # Print available battery
  battery = "acpi";

  # Rebuuild nixos
  rebuild = "sudo nixos-rebuild switch --flake ~/Projects/nixos-config/";

  # Render git repo using gource
  "git-render" = "gource -f -s 1 -c 4 --key";
}
