# DDClient is a dynamic dns service
{ config, ... }:
{
  imports = [ ../../common/optional/services/acme.nix ];

  services.ddclient = {
    enable = true;
    interval = "1m";
    configFile = config.sops.templates."ddclient.conf".path;
  };

  sops.templates."ddclient.conf".content = ''
    # General settings
    cache=/var/lib/ddclient # See the nixos module for details
    foreground=YES

    # Routers
    use=web, web=checkip.dyndns.com/, web-skip='Current IP Address: '

    # Protocols
    protocol=porkbun
    apikey=${config.sops.placeholder.porkbun_api_key}
    secretapikey=${config.sops.placeholder.porkbun_secret_api_key}
    real.lapetus.moonythm.dev
  '';
}

