{ config, ... }:
let
  user = config.services.pounce.user;

  # Helper template for networks
  makeNetworkConfig =
    {
      host,
      port,
      join,
      secret,
    }:
    {
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
  sops.templates."pounce-tilde.cfg" = makeNetworkConfig {
    host = "eu.tilde.chat";
    port = 6697;
    join = "#meta";
    secret = "tilde_irc_pass";
  };

  sops.secrets.freenode_irc_pass.sopsFile = ../secrets.yaml;
  sops.templates."pounce-freenode.cfg" = makeNetworkConfig {
    host = "irc.freenode.net";
    port = 6697;
    join = "#freenode";
    secret = "freenode_irc_pass";
  };

  sops.secrets.libera_irc_pass.sopsFile = ../secrets.yaml;
  sops.templates."pounce-libera.cfg" = makeNetworkConfig {
    host = "irc.libera.chat";
    port = 6697;
    join = "#libera";
    secret = "libera_irc_pass";
  };

  # Configure pounce
  services.pounce = {
    enable = true;
    externalHost = "irc.${config.satellite.dns.domain}";
    bindHost = "irc.${config.satellite.dns.domain}";
    certDir = "/var/lib/acme/wildcard-irc.moonythm.dev";
    networks.tilde.config = config.sops.templates."pounce-tilde.cfg".path;
    networks.freenode.config = config.sops.templates."pounce-freenode.cfg".path;
    networks.libera.config = config.sops.templates."pounce-libera.cfg".path;
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
