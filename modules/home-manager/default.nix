# (https://nixos.wiki/wiki/Module).

{
  # example = import ./example.nix;

  # Modules not yet added to the stable branch
  bemenu = import ./compat/bemenu.nix;
  hyprpaper = import ./compat/hyprpaper.nix;
  k9s = import ./compat/k9s.nix;

  # Personal things
  dev = import ./dev.nix;
  firefox = import ./firefox;
  monitors = import ./monitors.nix;
  satellite-persistence = import ./persistence.nix;

  # Should upstream
  discord = import ./discord.nix;
}
