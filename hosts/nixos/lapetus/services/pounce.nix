{ config, ... }:
let
  user = config.services.pounce.user;

  # Helper template for networks
  makeNetworkConfig = host: port: join: secret: {
    content = ''
      sasl-plain = prescientmoon:${config.sops.placeholder.${secret}}
      nick = prescientmoon
      host = ${host}
      port = ${toString port}
      join = ${join}
    '';
    owner = user;
  };
in
{
  # Generate cert
  security.acme.certs."wildcard-irc.moonythm.dev" = {
    group = user;
    domain = "*.irc.moonythm.dev";
  };

  # Handle secrets using sops
  sops.secrets.tilde_irc_pass.sopsFile = ../secrets.yaml;
  sops.templates."pounce-tilde.cfg" = makeNetworkConfig "eu.tilde.chat" 6697 "#meta" "tilde_irc_pass";

  # Configure pounce
  services.pounce = {
    enable = true;
    externalHost = "irc.${config.satellite.dns.domain}";
    bindHost = "irc.${config.satellite.dns.domain}";
    certDir = "/var/lib/acme/wildcard-irc.moonythm.dev";
    networks.tilde.config = config.sops.templates."pounce-tilde.cfg".path;
  };

  satellite.dns.records = [
    {
      type = "CNAME";
      at = "*.irc";
      to = "irc";
    }
    {
      type = "CNAME";
      at = "irc";
      to = config.networking.hostName;
    }
  ];
}
