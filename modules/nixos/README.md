# Nixos modules

| Name                           | Attribute               | Description                          |
| ------------------------------ | ----------------------- | ------------------------------------ |
| [pounce](pounce.nix)           | `services.pounce`       | Pounce & calico configuration        |
| [nginx](nginx.nix)             | `satellite.nginx`       | Nginx configuration                  |
| [cloudflared](cloudflared.nix) | `satellite.cloudflared` | Cloudflare tunnel configuration      |
| [pilot](pilot.nix)             | `satellite.pilot`       | Defines the concept of a "main user" |
