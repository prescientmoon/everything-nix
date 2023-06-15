# (https://nixos.wiki/wiki/Module).

{
  # example = import ./example.nix;

  # Personal things
  firefox = import ./firefox;
  monitors = import ./monitors.nix;
  satellite-dev = import ./satellite-dev.nix;
  satellite-persistence = import ./persistence.nix;

  # Should upstream
  discord = import ./discord.nix;
  hyprpaper = import ./hyprpaper.nix;
}
