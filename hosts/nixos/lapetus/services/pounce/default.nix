{
  config,
  lib,
  ...
}:
let
  user = config.services.pounce.user;

  networks = [
    {
      name = "tilde";
      host = "eu.tilde.chat";
      join = "#meta";
    }
    {
      name = "freenode";
      host = "irc.freenode.net";
      join = "#freenode";
    }
    {
      name = "libera";
      host = "irc.libera.chat";
      join = "#libera";
    }
    {
      name = "hackint";
      host = "irc.hackint.org";
      join = "#hackint,#tvl";
    }
    {
      name = "town";
      host = "localhost";
      join = "#tildetown,#websiteclub,#coworking";
      port = config.satellite.ports.tilde-town-irc;
      insecure = true; # The SSH tunnel encrypts this already
    }
  ];

  makeNetworkConfig =
    {
      name,
      host,
      join,
      port ? 6697,
      insecure ? false,
    }:
    {
      services.pounce.networks.${name}.config = config.sops.templates."pounce-${name}.cfg".path;
      sops.secrets."${name}_irc_pass".sopsFile = ../../secrets.yaml;
      sops.templates."pounce-${name}.cfg" = {
        content = ''
          sasl-plain = prescientmoon:${config.sops.placeholder."${name}_irc_pass"}
          nick = prescientmoon
          host = ${host}
          port = ${toString port}
          join = ${join}
          save = /persist/state/var/lib/pounce/${host}
          ${lib.optionalString insecure "insecure"}
        '';
        owner = user;
      };
    };
in
{
  imports = [
    ./module.nix
    ./tilde-town.nix
    { config = lib.mkMerge (lib.forEach networks makeNetworkConfig); }
  ];

  # Generate cert
  security.acme.certs."wildcard-irc.moonythm.dev" = {
    group = user;
    domain = "*.irc.moonythm.dev";
  };

  # Configure pounce
  services.pounce = {
    enable = true;
    externalHost = "irc.${config.satellite.dns.domain}";
    bindHost = "irc.${config.satellite.dns.domain}";
    certDir = "/var/lib/acme/wildcard-irc.moonythm.dev";
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
      to = "${config.networking.hostName}.overlay";
    }
  ];
}
