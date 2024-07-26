# (https://nixos.wiki/wiki/Module).

{
  # Personal things
  dev = import ./dev.nix;
  firefox = import ./firefox;
  monitors = import ./monitors.nix;
  satellite-persistence = import ./persistence.nix;

  # Should upstream
  discord = import ./discord.nix;
}
