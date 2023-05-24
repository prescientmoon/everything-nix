# (https://nixos.wiki/wiki/Module).

{
  # example = import ./example.nix;
  discord = import ./discord.nix;
  firefox = import ./firefox;
  satellite-dev = import ./satellite-dev.nix;
  satellite-persistence = import ./persistence.nix;
  wofi = import ./wofi.nix;
}
