# Nixos modules

| Name                                 | Attribute               | Description                          |
| ------------------------------------ | ----------------------- | ------------------------------------ |
| [pounce](pounce.nix)                 | `services.pounce`       | Pounce & calico configuration        |
| [nginx](nginx.nix)                   | `satellite.nginx`       | Nginx configuration                  |
| [ports](ports.nix)                   | `satellite.ports`       | Global port specification            |
| [cloudflared](cloudflared.nix)       | `satellite.cloudflared` | Cloudflare tunnel configuration      |
| [pilot](pilot.nix)                   | `satellite.pilot`       | Defines the concept of a "main user" |
| [dns](dns.nix)                       | `satellite.dns`         | DNS record creation                  |
| [dns-assertions](dns-assertions.nix) | `satellite.dns`         | DNS record validation                |
