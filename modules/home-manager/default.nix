# (https://nixos.wiki/wiki/Module).

{
  # example = import ./example.nix;

  # Personal things
  firefox = import ./firefox;
  satellite-dev = import ./satellite-dev.nix;
  satellite-persistence = import ./persistence.nix;
  monitors = import ./monitors.nix;

  # Should upstream
  discord = import ./discord.nix;
  hyprpaper = import ./hyprpaper.nix;

  # Temporary
  wofi = import ./wofi.nix;
}
