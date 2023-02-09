# (https://nixos.wiki/wiki/Module).

{
  # example = import ./example.nix;
  discord = import ./discord.nix;
  fonts = import ./fonts.nix;
  manage-fonts = import ./manage-fonts.nix;
  firefox = import ./firefox;
  satellite-dev = import ./satellite-dev.nix;
}
