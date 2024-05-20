# (https://nixos.wiki/wiki/Module).

{
  # example = import ./example.nix;
  cloudflared = import ./cloudflared.nix;
  nginx = import ./nginx.nix;
  pilot = import ./pilot.nix;
  pounce = import ./pounce.nix;
}
