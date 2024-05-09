# (https://nixos.wiki/wiki/Module).

{
  # example = import ./example.nix;
  cloudflaredd = import ./cloudflared.nix;
  nginx = import ./nginx.nix;
  pounce = import ./pounce.nix;
}
