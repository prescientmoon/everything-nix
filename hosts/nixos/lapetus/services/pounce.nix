{ config, ... }:
let makeNetworkConfig = host: port: join: secret: {
  content = ''
    sasl-plain = prescientmoon:${config.sops.placeholder.${secret}}
    nick = prescientmoon
    host = ${host}
    port = ${toString port}
    join = ${join}
  '';
  owner = config.services.pounce.user;
};
in
{
  security.acme.certs."wildcard-irc.moonythm.dev" = {
    group = config.services.pounce.user;
    domain = "*.irc.moonythm.dev";
  };

  sops.secrets.tilde_irc_pass.sopsFile = ../secrets.yaml;
  sops.templates."pounce-tilde.cfg" = makeNetworkConfig "eu.tilde.chat" 6697 "#meta" "tilde_irc_pass";
  services.pounce = {
    enable = true;
    externalHost = "irc.moonythm.dev";
    bindHost = "irc.moonythm.dev";
    certDir = "/var/lib/acme/wildcard-irc.moonythm.dev";
    networks.tilde.config = config.sops.templates."pounce-tilde.cfg".path;
  };
}
