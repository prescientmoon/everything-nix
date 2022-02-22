{
  ls = "exa -la";
  sl = "sl -e";

  # WIfi stuff
  wifi = "sudo nmcli con up id";

  # Volume controls
  vup = "amixer set Master 8%+";
  vdown = "amixer set Master 8%-";

  # Rebuuild nixos
  rebuild = "sudo nixos-rebuild switch --flake ~/Projects/nixos-config/";

  # Render git repo using gource
  "git-render" = "gource -f -s 1 -c 4 --key";
}
