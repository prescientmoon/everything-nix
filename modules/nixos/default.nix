# (https://nixos.wiki/wiki/Module).

{
  # example =  ./example.nix;
  cloudflared = ./cloudflared.nix;
  ports = ./ports.nix;
  nginx = ./nginx.nix;
  pilot = ./pilot.nix;
  pounce = ./pounce.nix;
}
